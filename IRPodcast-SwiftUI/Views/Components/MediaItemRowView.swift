//
//  MediaItemRowView.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/28.
//

import SwiftUI

protocol MediaItemRowProtocol {
    var title: String { get }
    var subtitle: String { get }
    var content: String { get }
    var footnote: String { get }
}

struct MediaItemRowView: View {
    
    let item: MediaItemRowProtocol
    
    var body: some View {
        HStack {
            Image(systemName: "book")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                                    
            VStack {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.callout)
                Text(item.content)
                    .font(.footnote)
                Text(item.footnote)
                    .font(.footnote)
//                Text(episode.author ?? "1")
//                Text(episode.author ?? "1")
//                Text(episode.author ?? "1")
//                Text(episode.author ?? "1")
            }
        }
    }
}

#Preview {
    List {
        let item = Episode(title: "title1",
                           releaseDate: .now,
                           description: "desc",
                           author: "author1")
        MediaItemRowView(item: item)
    }
}
