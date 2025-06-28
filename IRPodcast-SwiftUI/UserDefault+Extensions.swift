//
//  UserDefault+Extensions.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/29.
//

import Foundation
import SwiftUI
import Combine

protocol FavoritesManagerProtocol: ObservableObject {
    
    var favoritedPodcasts: [Podcast] { get }
    func add(_ podcast: Podcast)
    func remove(_ podcast: Podcast)
    init()
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

//extension UserDefaults {
//    
//    static let favoritedPodcastKey = "favoritedPodcastKey"
//    static let downloadedEpisodesKey = "downloadEpisodesKey"
//    
//    var savedPodcasts: [Podcast] {
//        get {
//            guard let savedPodcasts = try? self.get(objectType: [Podcast].self, forKey: UserDefaults.favoritedPodcastKey) else {
//                return []
//            }
//            return savedPodcasts
//        }
//        set(newSavedPodcasts) {
//            try? self.set(object: newSavedPodcasts, forKey: UserDefaults.favoritedPodcastKey)
//        }
//    }
//}

extension UserDefaults {
    
    func set<T: Codable>(object: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        self.set(data, forKey: key)
    }
    
    func get<T: Codable>(objectType: T.Type, forKey key: String) throws -> T? {
        guard let data = self.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(objectType, from: data)
    }
}
