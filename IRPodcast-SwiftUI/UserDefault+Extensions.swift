//
//  UserDefault+Extensions.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/29.
//

import Foundation
import SwiftUI
import Combine

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
