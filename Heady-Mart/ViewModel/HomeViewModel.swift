//
//  HomeViewModel.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 20/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

class HomeViewModel: CategoryProductViewModel {
    fileprivate(set) var state: CategoryState = CategoryState()
    var onChange: ((CategoryState.FetchState) -> Void)?
    
    func reloadData() {
        fetchFromDB()
        guard let categories = state.categories, categories.count > 0 else {
            fetchDataFromAPI()
            return
        }
        
        onChange?(.DBDataFetched)
        fetchDataFromAPI()
    }
    
    func fetchDataFromAPI() {
        ServiceManager.shared.fetchCategories {[weak self] (model) in
            guard let slf = self else { return }
            guard let categories = model else {
                slf.onChange?(.Error(.ErrorGettingData))
                return
            }
            slf.onChange?(.FreshDataFetched)
            slf.saveDataToDB(model: categories)
        }
    }
    
    func saveDataToDB(model: ProductAPIResource.ModelType) {
        CoreDataManager.shared.insertDataIntoDB(categoryRankingResponse: model, completion: {[weak self] success in
            guard let slf = self else {return}
            slf.onChange?(.DBDataUpdated)
        })
    }
    
    func fetchFromDB() {
        self.state.categories = CoreDataManager.shared.getCategories()
        self.state.rankings = CoreDataManager.shared.getRankings()
    }
}
