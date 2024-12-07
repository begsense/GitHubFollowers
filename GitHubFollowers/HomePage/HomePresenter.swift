//
//  HomePresenter.swift
//  GitHubFollowers
//
//  Created by M1 on 04.12.2024.
//

import UIKit

protocol HomePresentationLogic {
    func presentFollowers(response: HomeModels.HomeModel.Response)
    func presentError(error: String)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentFollowers(response: HomeModels.HomeModel.Response) {
        let viewModel = HomeModels.HomeModel.ViewModel(followers: response.followersData, error: nil)
        DispatchQueue.main.async {
            self.viewController?.displayFollowers(viewModel: viewModel)
        }
    }
    
    func presentError(error: String) {
        let errorViewModel = HomeModels.HomeModel.ViewModel(followers: nil, error: error)
        DispatchQueue.main.async {
            self.viewController?.displayError(viewModel: errorViewModel)
        }
    }
}
