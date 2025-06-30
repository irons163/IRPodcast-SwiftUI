//
//  FavoritesManager+Mock.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/8/4.
//

class MockFavoritesManager: FavoritesManagerProtocol {

    var favoritedPodcasts: [Podcast] = []

    required init() { }

    func add(_ podcast: Podcast) {
        favoritedPodcasts.append(podcast)
    }

    func remove(_ podcast: Podcast) {
        favoritedPodcasts.removeAll(where: { $0 == podcast })
    }
}
