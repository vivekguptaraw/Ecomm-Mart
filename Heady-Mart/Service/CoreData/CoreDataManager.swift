//
//  CoreDataManager.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack
    private lazy var managedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Heady_Mart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    // MARK: - Core Data Save
    func saveContext (completion: (Bool) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(true)
            } catch {
                let nserror = error as NSError
                completion(false)
                //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertDataIntoDB(categoryRankingResponse: CategoryRankingAPIResponse, completion: (Bool) -> Void) {
        parseDataForDB(apiResponseData: categoryRankingResponse, completion: completion)
    }
    
    private func parseDataForDB(apiResponseData: CategoryRankingAPIResponse, completion: (Bool) -> Void) {
        if let categoriesResponse = apiResponseData.categories, categoriesResponse.count > 0 {
            for categoryResponse in categoriesResponse {
                createCategoryEntity(categoryResponse: categoryResponse)
            }
        }
        saveContext(completion: { flag in
            if let rankings = apiResponseData.rankings, rankings.count > 0 {
                createRankingEntity(rankingsResponse: rankings)
                saveContext(completion: completion)
            } else {
                completion(false)
            }
        })
        
    }
    
     private func createCategoryEntity(categoryResponse: CategoryAPIModel) {
           let category = Category(context: self.managedObjectContext)
           if let id = categoryResponse.id, let i32 = Int32(id) as? Int32 {
               category.id = i32
           }
           
           category.name = categoryResponse.name
           
           let products = createProductEntity(productApiResp: categoryResponse.products)
           category.products = NSSet(array: products)
           category.childCategories = NSSet(array: createChildCategoryEntity(childCategoryResponse: categoryResponse.childCategories))
    }
    
    private func createProductEntity(productApiResp: [ProductAPIModel]?) -> [Product] {
           var products = [Product]()
           guard let productsResponseArray = productApiResp else { return products }
           
           for productResponse in productsResponseArray {
               let product = Product(context: self.managedObjectContext)
               product.id = Int16(productResponse.id ?? 0)
               product.name = productResponse.name ?? ""
               product.dateAdded = Helper.getDate(from: productResponse.dateAdded ?? "")
            
               let variants = createVariantEntity(variantsResponse: productResponse.variants)
               product.variants = NSSet(array: variants)
               
               if let taxResponse = productResponse.tax {
                   product.tax = createTaxEntity(taxResponse: taxResponse)
               }
               products.append(product)
           }
           return products
    }
    
    private func createVariantEntity(variantsResponse: [VariantAPIModel]?) -> [Variants] {
        var variants = [Variants]()
        guard let variantResponseArray = variantsResponse else { return variants }
        for variantResponse in variantResponseArray {
            let variant = Variants(context: self.managedObjectContext)
            variant.id = Int32(Int16(variantResponse.id ?? 0))
            variant.size = Int64(Int16(variantResponse.size ?? 0))
            variant.color = variantResponse.color ?? ""
            variant.price = Double(variantResponse.price ?? 0)
            variants.append(variant)
        }
        return variants
    }
    
    private func createTaxEntity(taxResponse: TaxAPIModel) -> Tax {
        let tax = Tax(context: self.managedObjectContext)
        tax.name = taxResponse.name ?? ""
        tax.value = taxResponse.value ?? 0.0
        return tax
    }
    
    private func createChildCategoryEntity(childCategoryResponse: [Int]?) -> [ChildCategory] {
        var childCategoriesArray = [ChildCategory]()
        
        if let childCategories = childCategoryResponse {
            for child in childCategories {
                let childCategory = ChildCategory(context: self.managedObjectContext)
                childCategory.id = Int16(child)
                childCategoriesArray.append(childCategory)
            }
        }
        return childCategoriesArray
    }
    
    private func createRankingEntity(rankingsResponse: [RankingAPIModel]?){
        var rankings = [Ranking]()
        var products = [Product]()
        do {
            products = try managedObjectContext.fetch(Product.fetchRequest())
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let rankingsArray = rankingsResponse {
            for rankingResponse in rankingsArray {
                let ranking = Ranking(context: self.managedObjectContext)
                ranking.ranking = rankingResponse.ranking ?? ""
                if let rankingProductApiResp = rankingResponse.products {
                    for rankingProduct in rankingProductApiResp {
                        if let prod = rankingProduct.addProductToRanking(products: products) {
                            ranking.addToProduct(prod)
                        }
                    }
                }
                rankings.append(ranking)
            }
        }
    }
    
    func getCategories() -> ([Category]) {
        do {
            let categories = try managedObjectContext.fetch(Category.fetchRequest())
            if let array = categories as? [Category] {
                return array
            }
        } catch {
            print("Error while fetching Categories")
        }
        return []
    }
    
    func getRankings() -> ([Ranking]) {
        do {
            let ranking = try managedObjectContext.fetch(Ranking.fetchRequest())
            if let array = ranking as? [Ranking] {
                return array
            }
        } catch {
            print("Error while fetching Ranking")
        }
        return []
    }
}
