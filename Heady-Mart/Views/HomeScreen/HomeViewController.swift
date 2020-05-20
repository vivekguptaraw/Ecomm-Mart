//
//  HomeViewController.swift
//  Heady-Mart
//
//  Created by Vivek Gupta on 17/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeViewModel?
    lazy var header: CategoryHeaderView = {
        let hdr = CategoryHeaderView.loadFromNib()
        hdr.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 240))
        return hdr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewModel()
        self.tableView.tableHeaderView = header
    }
    
    func setViewModel() {
        viewModel = HomeViewModel()
        viewModel?.onChange = changes
        viewModel?.reloadData()
    }
    
    func changes(change: CategoryState.FetchState) {
        switch change {
        case .FreshDataFetched:
            print("==> FreshDataFetched")
            setData()
        case .DBDataFetched:
            print("==> FreshDataFetched")
            setData()
        case .DBDataUpdated:
            print("==> FreshDataFetched")
            setData()
        case .Error(let error):
            switch error {
            case .ErrorGettingData:
                print("==> Error ErrorGettingData")
            case .ParsingFailed:
                print("==> Error ParsingFailed")
            case .RetriesExhausted:
                print("==> Error RetriesExhausted")
            }
        }
    }
    
    func setData() {
        DispatchQueue.main.async {[weak self] in
            guard let slf = self else {return}
            slf.header.categories = slf.viewModel?.state.categories
            slf.tableView.reloadData()
        }
    }


}

