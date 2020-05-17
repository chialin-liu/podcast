//
//  EpisodesController.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/12.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
import FeedKit
class EpisodesController: UITableViewController {
    var podcast: Podcast? {
        didSet {
            self.navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    var episodes = [Episode]()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
        setupNavigationBarButton()
    }
    // MARK: - fetchEpisodes
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        //change feedurl to https:
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - setup save favorite
    let favoritePodcastKey = "favoritePodcastKey"
    func setupNavigationBarButton() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
            UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcast))
        ]
    }
    @objc func handleFetchSavedPodcast() {
        guard let data = UserDefaults.standard.data(forKey: favoritePodcastKey) else { return }
        let decoder = PropertyListDecoder()
        if let podcast = try? decoder.decode(Podcast.self, from: data) {
            print("podcast trackName", podcast.trackName ?? "")
        }
    }
    @objc func handleSaveFavorite() {
        print("right click")
        guard let podcast = self.podcast else { return }
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(podcast)
            UserDefaults.standard.set(data, forKey: favoritePodcastKey)
        } catch let err {
            print("Failed to archive", err)
        }
    }
    // MARK: - setup cell
    func setupCell() {
// WRONG WRITING       tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        //TBD: to remove lines shows below
        tableView.tableFooterView = UIView()
    }
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .darkGray
        activity.startAnimating()
        return activity
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabController.maxmizePlayerDetail(episode: episode, playListEpisodes: self.episodes)
//        let window = UIApplication.shared.keyWindow
//        //loadNibNamed is important
//        let playerDetailView = PlayerDetailView.initFromNib()
//        playerDetailView.frame = self.view.frame
//        playerDetailView.episode = episode
//        window?.addSubview(playerDetailView)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else { return EpisodeCell() }
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
