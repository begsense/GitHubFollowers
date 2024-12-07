//
//  HomeInteractor.swift
//  GitHubFollowers
//
//  Created by M1 on 04.12.2024.
//

import UIKit

protocol HomeBusinessLogic {
    func requestByUsername(requestUsername: HomeModels.HomeModel.Request)
}

class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    var worker: HomeWorker?
    
    func requestByUsername(requestUsername: HomeModels.HomeModel.Request) {
        let url = "https://api.github.com/users/\(requestUsername.username)/followers"
        worker = HomeWorker()
        Task {
            do {
                let followers = try await worker?.fetchData(urlString: url, type: [Followers].self) ?? []
                let response = HomeModels.HomeModel.Response(followersData: followers)
                presenter?.presentFollowers(response: response)
            } catch let error as NetworkError {
                let errorMessage = handleError(error)
                presenter?.presentError(error: errorMessage)
            } catch {
                presenter?.presentError(error: error.localizedDescription)
            }
        }
    }
    
    private func handleError(_ error: NetworkError) -> String {
        switch error {
        case .urlError:
            return "Invalid URL."
        case .decodeError:
            return "Failed to decode the response."
        case .wrongResponse:
            return "Received an invalid response."
        case .wrongStatusCode(let code):
            return "Unexpected status code: \(code)."
        }
    }
}
