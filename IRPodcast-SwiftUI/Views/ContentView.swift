//
//  ContentView.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/27.
//

import SwiftUI

struct ContentView: View {
    var podcasts: [Podcast] = [
        Podcast(id: "1", content: "contnet1", subtitle: "subtile1"),
        Podcast(id: "2", content: "contnet2", subtitle: "subtile2"),
        Podcast(id: "3", content: "contnet3", subtitle: "subtile3")
    ]

    var body: some View {
        TabView {
            SearchView(list: podcasts).tabItem {
                Text("Search")
            }
            FavoriteView(manager: Current.favoritesManager).tabItem {
                Text("Favorite")
            }
            DownloadView(list: podcasts).tabItem {
                Text("Download")
            }
        }
    }
}

#Preview {
    ContentView()
}
