//
//  EpisodeListView.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/29.
//

import SwiftUI

struct EpisodeListView: View {

    var body: some View {
        List([Episode()], id: \.author) { episode in
            HStack {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                                        
                VStack {
                    Text(episode.author ?? "1")
                    Text(episode.author ?? "1")
                    Text(episode.author ?? "1")
                    Text(episode.author ?? "1")
                }
            }
        }
    }
}

#Preview {
    EpisodeListView()
}
