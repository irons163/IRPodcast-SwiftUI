//
//  MediaItemListView.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/28.
//

import SwiftUI

struct MediaItemListView<V: View>: View {
    
    let list: [Podcast]
//    let swipeAction: (Int) -> Void
    let swipeActions: ((_ p: Podcast) -> V)
    var onTapGesture: ((_ p: Podcast) -> Void)?
    
    var body: some View {
        List {
            ForEach(list) { i in
//                HStack {
//                    Image(systemName: "book")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                    VStack(alignment: .leading) {
//                        Text(i.id)
//                            .font(.headline)
//                        Text(i.content)
//                            .font(.callout)
//                        Text(i.subtitle)
//                            .font(.footnote)
//                        Text(i.releaseDate?.formatted() ?? "")
//                            .font(.footnote)
//                    }
//                }
                MediaItemRowView(item: i)
                .swipeActions(edge: .trailing) {
                    swipeActions(i)
                }
                .onTapGesture {
                    _ = onTapGesture?(i)
                }
            }
        }
    }
}

extension MediaItemListView where V == EmptyView {

    init(list: [Podcast]) {
        self.init(list: list,
                  swipeActions: { _ in EmptyView() },
                  onTapGesture: { _ in })
    }
}

#Preview {
    let list: [Podcast] = [
        Podcast(id: "1", content: "contnet1", subtitle: "subtile1", title: "title1", releaseDate: .now, author: "author1"),
        Podcast(id: "2", content: "contnet2", subtitle: "subtile2", title: "title2", releaseDate: .now, author: "author2")
    ]
    MediaItemListView(list: list)
}
