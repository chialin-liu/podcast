//
//  SearchResults.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/10.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
