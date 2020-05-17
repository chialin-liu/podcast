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
    func deletePodcast(podcast: Podcast) {
        var newPodcasts = [Podcast]()
        let savedPodcasts = fetchSavedPodcasts()
        for item in savedPodcasts {
            if item.trackName != podcast.trackName || item.artistName != podcast.artistName {
                newPodcasts.append(item)
            }
        }
        let encoder = PropertyListEncoder()
        do {
            let encodedData = try encoder.encode(newPodcasts)
            UserDefaults.standard.set(encodedData, forKey: UserDefaults.favoritePodcastKey)
        } catch let err {
            print("Save userdata failed", err)
        }
    }
}
