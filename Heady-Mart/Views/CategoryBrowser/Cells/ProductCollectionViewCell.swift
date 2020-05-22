//
//  ProductCollectionViewCell.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 22/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, ConfigurableCell {
    
    typealias T = Product
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ item: Product, at indexPath: IndexPath) {
        label.text = item.name
    }
    
    

}
