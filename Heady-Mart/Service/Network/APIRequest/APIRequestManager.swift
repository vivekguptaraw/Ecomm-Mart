//
//  APIRequestManager.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

final class ServiceManager {
    static let shared: ServiceManager = ServiceManager()
    private init() {}
}

extension ServiceManager: IAPIs {
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
