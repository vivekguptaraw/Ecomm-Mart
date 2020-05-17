//
//  IAPIResource.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

protocol IApiResource: HttpRequest {
    associatedtype ModelType: Codable
}
