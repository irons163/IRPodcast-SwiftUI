//
//  FavoritesManager.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/8/4.
//

import Combine

protocol FavoritesManagerProtocol: ObservableObject {

    var favoritedPodcasts: [Podcast] { get }
    func add(_ podcast: Podcast)
    func remove(_ podcast: Podcast)
    init()
}

class FavoritesManager: FavoritesManagerProtocol {
    @Published var favoritedPodcasts: [Podcast] = []

    private let store = FavoritesDataStore()

    required init() {
        self.favoritedPodcasts = store.fetch()
    }

    func add(_ podcast: Podcast) {
        favoritedPodcasts.append(podcast)
        store.save(favoritedPodcasts) // 呼叫 store 來儲存
    }

    func remove(_ podcast: Podcast) {
        favoritedPodcasts.removeAll(where: { $0 == podcast })
        store.save(favoritedPodcasts) // 呼叫 store 來儲存
    }
}

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
