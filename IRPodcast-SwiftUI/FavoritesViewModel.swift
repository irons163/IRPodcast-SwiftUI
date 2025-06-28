//
//  FavoritesViewModel.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/8/4.
//

import Combine

class FavoritesViewModel: ObservableObject {

    @Published private(set) var podcasts: [Podcast] = []

    private let manager: FavoritesManager
    private var cancellable: AnyCancellable?

    init(manager: FavoritesManager = FavoritesManager()) {
        self.manager = manager
        cancellable = manager.objectWillChange.sink { [weak self] _ in
            self?.podcasts = self?.manager.favoritedPodcasts ?? []
        }
    }
}
