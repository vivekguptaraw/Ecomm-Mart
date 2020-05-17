//
//  APIRequestManager.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

final class ApiRequestManager {
    static let shared: ApiRequestManager = ApiRequestManager()
    
    private init() {
        
    }
    
    func setUp() {
        
    }
}

extension ApiRequestManager: IAPIs {
    func fetchCategories(completion: @escaping (ProductAPIResource.ModelType?) -> Void) {
        let resource = ProductAPIResource()
        let request = APIRequest(resource: resource)
        request.load { (response: APIResponseType<ProductAPIResource.ModelType>) in
            switch response.result {
            case .success(let model):
                print(model)
                completion(model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
