//
//  HomeRouter.swift
//  GitHubFollowers
//
//  Created by M1 on 04.12.2024.
//

import UIKit
import SwiftUI

protocol HomeRoutingLogic {
    func routeToFollowersView(followers: [Followers])
}

class HomeRouter: NSObject, HomeRoutingLogic {
    weak var viewController: HomeViewController?
    
    func routeToFollowersView(followers: [Followers]) {
        var followersView = FollowersView()
        followersView.followers = followers
        viewController?.navigationController?.pushViewController(UIHostingController(rootView: followersView), animated: true)
    }
}
