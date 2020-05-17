//
//  Podcast.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/9.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
//class Podcast: NSObject, Decodable, NSCoding {
//    func encode(with coder: NSCoder) {
//        coder.encode(trackName ?? "", forKey: "trackNameKey")
//        coder.encode(artistName ?? "", forKey: "artistNameKey")
//        coder.encode(artworkUrl600 ?? "", forKey: "artworkUrl600Key")
//    }
//    required init?(coder: NSCoder) {
//        print("")
//        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
//        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
//        self.artworkUrl600 = coder.decodeObject(forKey: "artworkUrl600Key") as? String
//    }
//    //to use optional-> because some url response will not have these properties
//    var trackName: String?
//    var artistName: String?
//    var artworkUrl600: String?
//    var trackCount: Int?
//    var feedUrl: String?
//}
struct Podcast: Codable {
    //to use optional-> because some url response will not have these properties
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
