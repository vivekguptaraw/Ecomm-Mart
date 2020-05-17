//
//  APIRequest.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

struct APIRequest<Resource: IApiResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: INetworkRequestable {
    typealias ModelType = Resource.ModelType
    
    func load<T>(withCompletion completion: @escaping (APIResponseType<T>) -> Void) where T : Codable {
        self.request(resource) { (apiResponse: APIResponseType<T>) in
            completion(apiResponse)
        }
    }
}
