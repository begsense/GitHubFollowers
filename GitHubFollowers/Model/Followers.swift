//
//  Followers.swift
//  GitHubFollowers
//
//  Created by M1 on 04.12.2024.
//

import Foundation

struct Followers: Decodable, Identifiable {
    var id: String { login }
    
    let login: String
    let avatar_url: String
}
