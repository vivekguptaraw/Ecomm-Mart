//
//  CategoryViewModel.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 22/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

class CategoryViewModel {
    
    var categories: [Category]
    var leafCategory: Category?
    var grandLeafCategory: Category?
    var grandLeafs = [Category]()
    
    var category: Category? {
        didSet {
            setChilds(leafIndex: 0, grandLeafIndex: 0)
        }
    }
    
    init() {
        categories = CoreDataOperations.shared.getCategories()
    }
    
    func setChilds(leafIndex: Int, grandLeafIndex: Int) {
        guard let allChildCategories = category?.childCategories?.allObjects as? [ChildCategory] else {return}
        guard let leafCat = getCategory(id: allChildCategories[leafIndex].id) else {
            return
        }
        self.leafCategory = leafCat
        grandLeafs.removeAll()
        if let grandLeaf = leafCat.childCategories?.allObjects as? [ChildCategory] {
            for index in grandLeaf {
                grandLeafs.append(getCategory(id: Int16(index.id))!)
            }
            if let grandleafCat = getCategory(id: Int16(grandLeafs[grandLeafIndex].id)) {
                grandLeafCategory = grandleafCat
            }
        }
    }
    
    func getCategory(id: Int16) -> Category? {
        return categories.first{ $0.id == id} ?? nil
    }
    
    
}
