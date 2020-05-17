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
    static let downloadedEpisodeKey = "downloadedEpisodeKey"
    func downloadEpisode(episode: Episode) {
        var downloadedEpisodes = fetchDownloadedEpisodes()
        downloadedEpisodes.insert(episode, at: 0)
        guard let data = try? JSONEncoder().encode(downloadedEpisodes) else { return }
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
    }
    func fetchDownloadedEpisodes() -> [Episode] {
        guard let readData = UserDefaults.standard.data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
        guard let episodes = try? JSONDecoder().decode([Episode].self, from: readData) else { return [] }
        return episodes
    }
    func fetchSavedPodcasts() -> [Podcast] {
        guard let readData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else { return [] }
        let decoder = PropertyListDecoder()
        guard let savedPodcasts = try? decoder.decode([Podcast].self, from: readData) else { return[] }
        return savedPodcasts
    }
    func deleteEpisode(episode: Episode) {
        var newEpisodes = [Episode]()
        let downloadedEpisodes = fetchDownloadedEpisodes()
        for item in downloadedEpisodes {
            if item.title != episode.title || item.author != episode.author || item.description != episode.description {
                newEpisodes.append(item)
            }
        }
        guard let data = try? JSONEncoder().encode(newEpisodes) else { return }
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
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
