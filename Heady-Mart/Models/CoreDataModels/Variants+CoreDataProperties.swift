//
//  Variants+CoreDataProperties.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//
//

import Foundation
import CoreData


extension Variants {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variants> {
        return NSFetchRequest<Variants>(entityName: "Variants")
    }

    @NSManaged public var price: Double
    @NSManaged public var size: Int64
    @NSManaged public var color: String?
    @NSManaged public var id: Int32
    @NSManaged public var product: NSSet?

}

// MARK: Generated accessors for product
extension Variants {

    @objc(addProductObject:)
    @NSManaged public func addToProduct(_ value: Product)

    @objc(removeProductObject:)
    @NSManaged public func removeFromProduct(_ value: Product)

    @objc(addProduct:)
    @NSManaged public func addToProduct(_ values: NSSet)

    @objc(removeProduct:)
    @NSManaged public func removeFromProduct(_ values: NSSet)

}
