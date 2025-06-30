//
//  SearchView.swift
//  IRPodcast-SwiftUI
//
//  Created by Phil on 2025/6/27.
//

import SwiftUI
import FeedKit

class PodcastViewModel {
    @Published var podcasts: [Podcast] = []
}

//class PodcastViewModel: ObservableObject {
//    // This is the property that SwiftUI will watch for changes.
//    @Published var podcasts: [Podcast] = []
//
//    func toggleFavorite(for podcast: Podcast) {
//        // Logic to find and update the favorite status.
//        // Since 'podcasts' is @Published, any change will update the UI.
//    }
//
//    func fetchPodcasts() {
//        // Logic to fetch data and update the 'podcasts' array.
//    }
//}

@propertyWrapper
struct StringCodable: Codable, Equatable {
    var wrappedValue: String

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            wrappedValue = stringValue
        } else if let intValue = try? container.decode(Int.self) {
            wrappedValue = String(intValue)
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Int"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

struct Podcast: MediaItemRowProtocol, Codable, Identifiable {

    var footnote: String {
        releaseDate?.formatted() ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case content = "artistName"
        case collectionName
        case subtitle = "country"
//        case title
        case releaseDate
//        case description
//        case author
//        case streamUrl
//        case fileUrl
//        case imageUrl
    }

    @StringCodable var id: String
    var content: String = ""
    var collectionName: String = ""
    var subtitle: String = ""
    
    var title: String = ""
    var releaseDate: Date?
    var description: String?
    var author: String?
    var streamUrl: String?

    var fileUrl: String?
    var imageUrl: String?
}

extension Podcast {

    init(feedItem: RSSFeedItem) {
        let author = feedItem.iTunes?.author ?? ""
        self.author = author
        let title = feedItem.title ?? ""
        self.title = title
        let streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.streamUrl = streamUrl
        let releaseDate = feedItem.pubDate ?? Date()
        self.releaseDate = releaseDate
        self.id = feedItem.guid?.text ?? (
            author + title + streamUrl + releaseDate.ISO8601Format()
        )
        self.content = "1"
        self.subtitle = "1"
        self.description = feedItem.iTunes?.subtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.image?.attributes?.href
    }
}

extension Podcast: Equatable { }

struct Episode: MediaItemRowProtocol, Codable {
    
    var subtitle: String {
        author ?? ""
    }
    
    var content: String {
        description ?? ""
    }
    
    var footnote: String {
        releaseDate?.formatted() ?? ""
    }
    
    var title: String = ""
    var releaseDate: Date?
    var description: String?
    var author: String?
    var streamUrl: String?

    var fileUrl: String?
    var imageUrl: String?
}

struct SearchView: View {

    @State var search = ""
    @State var list: [Podcast]
//    @State var added = false
    @StateObject var manager = Current.favoritesManager
    
    var body: some View {
        NavigationStack {
            VStack {
                MediaItemListView(list: list) { podcast in
                    let isAdded = manager.favoritedPodcasts.contains(podcast)
                    return Button(isAdded ? "Remove Favorite" : "Add Favorite") {
                        if isAdded {
                            manager.remove(podcast)
                        } else {
                            manager.add(podcast)
                        }
//                        added = !added
                    }
                } onTapGesture: { podcast in
                    NavigationLink {
                        EpisodeListView()
                    } label: {
                        Text("GO")
                    }
                }
                    .navigationTitle("Search")
            }
        }
        .searchable(text: $search, prompt: "Podcast Name")
        .onSubmit(of: .search) {
            Task {
                do {
                    list = try await Current.networkService.fetchPodcasts(searchText: search)
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
//    let manager = Current.favoritesManager
    let list: [Podcast] = [Podcast(id: "1", content: "contnet1", subtitle: "subtile1"),
                Podcast(id: "2", content: "contnet2", subtitle: "subtile2")]
    SearchView(list: list)
}
