//
//  HomeModels.swift
//  GitHubFollowers
//
//  Created by M1 on 04.12.2024.
//

import UIKit

enum HomeModels {
    
    enum HomeModel {
        struct Request {
            let username: String
        }
        struct Response {
            let followersData: [Followers]
        }
        struct ViewModel {
            let followers: [Followers]?
            let error: String?
        }
    }
    
}
