//
//  Podcast.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/9.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
struct Podcast: Decodable {
    //to use optional-> because some url response will not have these properties
    var trackName: String?
    var artistName: String?
}
