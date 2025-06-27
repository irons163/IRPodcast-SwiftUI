//
//  NetworkService.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/29.
//

import Foundation
import FeedKit

let Current = A()
//let Current = Environment.live
//let Current: Environment = Environment.mock

protocol Environment2 {
    associatedtype T: FavoritesManagerProtocol
    var favoritesManager: T { get }
    associatedtype K: NetworkServiceProtocol
    var networkService: K { get }
}

struct A: Environment2 {
    var favoritesManager: FavoritesManager = FavoritesManager()
    var networkService: NetworkService2 = NetworkService2()
}

struct Environment {
    let networkService: NetworkService
    let favoritesManager: any FavoritesManagerProtocol

    static let live = Environment(networkService: NetworkService(), favoritesManager: FavoritesManager())
}

extension Environment {
    static let mock = Environment(networkService: NetworkService.mock, favoritesManager: FavoritesManager.mock)
}

struct NetworkService2: NetworkServiceProtocol {
    
    private static let baseiTunesSearchURL = "https://itunes.apple.com/search"

    func fetchPodcasts(searchText: String) async throws -> [Podcast] {
        var components = URLComponents(string: Self.baseiTunesSearchURL, encodingInvalidCharacters: true)
        components?.queryItems = [
            URLQueryItem(name: "term", value: searchText),
            URLQueryItem(name: "media", value: "podcast")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        print(url)
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let searchResult = try decoder.decode(SearchResult.self, from: data)
        return searchResult.results
    }
    
    func fetchEpisodes(feedUrl: String) async throws -> [Podcast] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: feedUrl)!)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try Feed(data: data).rss?.toEpisodes() ?? []
    }
    
    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}

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

extension FavoritesManager {
    static let mock = MockFavoritesManager()
}

protocol NetworkServiceProtocol {
    func fetchPodcasts(searchText: String) async throws -> [Podcast]
    func fetchEpisodes(feedUrl: String) async throws -> [Podcast]
}
//
//struct MockNetworkService {
//
//    func fetchPodcasts(searchText: String) async throws -> [Podcast] {
//        
//    }
//
//    func fetchEpisodes(feedUrl: String) async throws -> [Podcast] {
//        
//    }
//}

struct NetworkService {
    
    private static let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    var fetchPodcasts: (_ searchText: String) async throws -> [Podcast] = fetchPodcasts(searchText:)
    var fetchEpisodes: (_ feedUrl: String) async throws -> [Podcast] = fetchEpisodes(feedUrl:)
    
    static func fetchPodcasts(searchText: String) async throws -> [Podcast] {
        var components = URLComponents(string: Self.baseiTunesSearchURL, encodingInvalidCharacters: true)
        components?.queryItems = [
            URLQueryItem(name: "term", value: searchText),
            URLQueryItem(name: "media", value: "podcast")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        print(url)
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let searchResult = try decoder.decode(SearchResult.self, from: data)
        return searchResult.results
    }
    
    static func fetchEpisodes(feedUrl: String) async throws -> [Podcast] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: feedUrl)!)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try Feed(data: data).rss?.toEpisodes() ?? []
    }
}

extension NetworkService {

    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}

extension RSSFeed {

    func toEpisodes() -> [Podcast] {
        let imageUrl = channel?.iTunes?.image?.attributes?.href

        var episodes = [Podcast]()
        channel?.items?.forEach({ feedItem in
            var episode = Podcast(feedItem: feedItem)

            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }

            episodes.append(episode)
        })

        return episodes
    }

}
