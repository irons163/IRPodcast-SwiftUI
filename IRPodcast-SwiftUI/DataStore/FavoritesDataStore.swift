//
//  FavoritesDataStore.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/8/4.
//

import Foundation

struct FavoritesDataStore {

    private let userDefaults = UserDefaults.standard
    private let favoritedPodcastKey = "favoritedPodcastKey"

    func fetch() -> [Podcast] {
        guard let savedPodcasts = try? userDefaults.get(objectType: [Podcast].self, forKey: favoritedPodcastKey) else {
            return []
        }
        return savedPodcasts
    }

    func save(_ podcasts: [Podcast]) {
        try? userDefaults.set(object: podcasts, forKey: favoritedPodcastKey)
    }
}
