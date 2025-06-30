//
//  NetworkService+Mocks.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/8/4.
//

extension NetworkService {
    static let mock = NetworkService { searchText in
        let list: [Podcast] = [
            Podcast(id: "mock1", content: "contnet1", subtitle: "subtile1"),
            Podcast(id: "mock2", content: "contnet2", subtitle: "subtile2"),
            Podcast(id: "mock3", content: "contnet3", subtitle: "subtile3")
        ]
        return list
    } fetchEpisodes: { feedUrl in
        return []
    }
}
