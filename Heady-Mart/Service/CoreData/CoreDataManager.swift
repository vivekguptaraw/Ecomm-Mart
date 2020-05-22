//
//  CoreDataManager.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    let persistentContainerQueue = OperationQueue()
   
    private init() {
         persistentContainerQueue.maxConcurrentOperationCount = 1
    }

    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Heady_Mart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            container.viewContext.automaticallyMergesChangesFromParent = true
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        moc.parent = self.persistentContainer.viewContext
        return moc
    }()
    
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        var moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = self.persistentContainer.viewContext
        return moc
    }()
    
    func saveContext (completion: @escaping (Bool) -> Void) {
        persistentContainerQueue.addOperation() {
            self.managedObjectContext.performAndWait({
                do {
                    if self.managedObjectContext.hasChanges {
                        try self.managedObjectContext.save()
                        completion(true)
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Managed Object Context")
                    completion(false)
                }
            })
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Unable to Save Changes of Managed Object Context")
                }
            }
            
            self.mainManagedObjectContext.performAndWait({
                do {
                    if self.mainManagedObjectContext.hasChanges {
                        try self.mainManagedObjectContext.save()
                    }
                } catch {
                    let saveError = error as NSError
                    print("Unable to Save Changes of Managed Object Context")
                    
                }
            })
            
        }
        
    }
}

protocol NSManagedObjectEntityName: class{}

extension NSManagedObjectEntityName where Self: NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}

extension NSManagedObject: NSManagedObjectEntityName {}


extension NSManagedObject {
    class func findOrCreate<T: NSManagedObject>(condition: Any? = nil, MOC: NSManagedObjectContext) ->  T {
        let fetchRequest = self.getFetchRequest()
        if let cntn = condition {
            fetchRequest.predicate = self.predicate(formCondition: cntn)
        }
        if let objects = self.fetch(fetchRequest: fetchRequest, MOC: MOC) {
            if let object = objects.first {
                
                return object as! T
            }
        }
        return NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: MOC) as! T
    }
    
    private class func predicate(formCondition condition: Any) -> NSPredicate? {
        if let dictionary = condition as? [String: Any] {
            let predicateArray = dictionary.flatMap({ (arg) -> NSPredicate? in
                let (key, value) = arg
                return NSPredicate(format: "\(key) = %@",value as! CVarArg)
            })
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicateArray)
        }else if let predicate  = condition as? NSPredicate {
            return predicate
        }else if let string = condition as? String {
            return NSPredicate(format: string, TID_NULL)
        }
        return nil
    }
    
    private class func fetch <T: NSManagedObject>(fetchRequest: NSFetchRequest<NSManagedObject>, MOC: NSManagedObjectContext) -> [T]? {
        do {
            if let objects = try MOC.fetch(fetchRequest) as? [T] {
                return objects
            }
        }catch {
            
        }
        return nil
    }
    
    private class func getFetchRequest<T: NSManagedObject>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: self.entityName)
    }
}
