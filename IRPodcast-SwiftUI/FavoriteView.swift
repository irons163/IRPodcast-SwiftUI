//
//  FavoriteView.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/28.
//

import SwiftUI

struct FavoriteView<T: FavoritesManagerProtocol>: View {
    
    @ObservedObject var manager: T
    
    var body: some View {
        NavigationStack {

            ScrollView {
                LazyVGrid(columns: [GridItem(spacing: 16), GridItem()], alignment: .center, spacing: 16) {
                    ForEach(manager.favoritedPodcasts) { item in
                        ZStack {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(.blue.opacity(0.2))
                            VStack {
                                Image(systemName: "book")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                Text(item.content)
                                Text(item.subtitle)
                                    .padding(.bottom, 16)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .navigationTitle("Favorite")
        }
    }
}

#Preview {
    let list: [Podcast] = [
        Podcast(id: "1", content: "contnet1", subtitle: "subtile1"),
        Podcast(id: "2", content: "contnet2", subtitle: "subtile2"),
        Podcast(id: "3", content: "contnet3", subtitle: "subtile3")
    ]
    FavoriteView(manager: FavoritesManager())
}
