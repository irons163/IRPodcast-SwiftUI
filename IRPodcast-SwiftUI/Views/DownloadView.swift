//
//  DownloadView.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/28.
//

import SwiftUI

struct DownloadView: View {

    let list: [Podcast]

    var body: some View {
        MediaItemListView(list: list)
    }
}

#Preview {
    let podcasts: [Podcast] = [
        .init(id: "1", content: "1", subtitle: "subtitle1"),
        .init(id: "2", content: "2", subtitle: "subtitle2")
    ]
    DownloadView(list: podcasts)
}
