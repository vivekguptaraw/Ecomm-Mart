//
//  UIColor.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 20/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 3...4),
                       green: .random(in: 5...6),
                       blue: .random(in: 7...8),
                       alpha: 0.5)
    }
    
    static var randomDark: UIColor {
           return UIColor(red: .random(in: 3...4),
                          green: .random(in: 5...6),
                          blue: .random(in: 7...8),
                          alpha: 1)
    }
}
