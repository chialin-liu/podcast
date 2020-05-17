//
//  UserDefault.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/17.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
extension UserDefaults {
    static let favoritePodcastKey = "favoritePodcastKey"
    func fetchSavedPodcasts() -> [Podcast] {
        guard let readData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return [] }
        let decoder = PropertyListDecoder()
        
        guard let savedPodcasts = try? decoder.decode([Podcast].self, from: readData) else { return[] }
        return savedPodcasts
    }
}
