//
//  EnvironmentWithProtocol.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/8/4.
//

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
