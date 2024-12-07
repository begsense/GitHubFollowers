//
//  FollowersView.swift
//  GitHubFollowers
//
//  Created by M1 on 07.12.2024.
//

import SwiftUI

struct FollowersView: View {
    var followers: [Followers] = []
    private var columns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        ScrollView {
            if followers.isEmpty {
                Text("User have no followers")
            } else {
                VStack {
                    ForEach(followers) { index in
                        VStack {
                            AsyncImage(url: URL(string: index.avatar_url)) { image in
                                image.resizable()
                                    .frame(width: 100, height: 100)
                                    .scaledToFit()
                                    .cornerRadius(15)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text(index.login)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FollowersView()
}
