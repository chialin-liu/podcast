//
//  Episode.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/12.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import FeedKit
struct Episode: Codable {
    let title: String
    let pubDate: Date
    let description: String
    let author: String
    let streamUrl: String
    //assume the imageUrl will not exist
    var imageUrl: String?
    var fileUrl: String?
    init(feedItem: RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ??  feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        //remove the intial value "" empty string below
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    }
}
