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
    var hasFavorited: Bool = false
    func setupNavigationBarButton() {
        hasFavorited = false
        let savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
        for item in savedPodcasts {
            if item.trackName == self.podcast?.trackName {
                hasFavorited = true
            }
        }
        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDeleteFavorite))
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "Add Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
//                UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcast))
            ]
        }
    }
    @objc func handleDeleteFavorite() {
        print("Delete favorite in heart image")
        guard let podcast = self.podcast else { return }
        UserDefaults.standard.deletePodcast(podcast: podcast)
        UIApplication.mainTabController().viewControllers?[1].tabBarItem.badgeValue = nil
        setupNavigationBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarButton()
    }
    @objc func handleFetchSavedPodcast() {
        guard let data = UserDefaults.standard.data(forKey: favoritePodcastKey) else { return }
        let decoder = PropertyListDecoder()
        if let savedPodcasts = try? decoder.decode([Podcast].self, from: data) {
            for podcast in savedPodcasts {
                print("podcast trackName:", podcast.trackName ?? "")
            }
        }
    }
    @objc func handleSaveFavorite() {
        print("save favorites")
        guard let podcast = self.podcast else { return }
        do {
            var listPodcasts = UserDefaults.standard.fetchSavedPodcasts()
            listPodcasts.append(podcast)
            let encoder = PropertyListEncoder()
            let encodedData = try encoder.encode(listPodcasts)
            UserDefaults.standard.set(encodedData, forKey: favoritePodcastKey)
            showBadgeHightLight()
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDeleteFavorite))
        } catch let err {
            print("Fetch failed ", err)
        }
    }
    func showBadgeHightLight() {
        UIApplication.mainTabController().viewControllers?[1].tabBarItem.badgeValue = "New"
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
    func showDownloadHightLight() {
        UIApplication.mainTabController().viewControllers?[2].tabBarItem.badgeValue = "New"
    }
    var hasDownLoaded: Bool = false
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let episode = episodes[indexPath.row]
        hasDownLoaded = false
        let downloadedEpisodes = UserDefaults.standard.fetchDownloadedEpisodes()
        for item in downloadedEpisodes {
            if item.author == episode.author && item.title == episode.title && item.description == episode.description {
                hasDownLoaded = true
            }
        }
        if !hasDownLoaded {
            let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
                let episode = self.episodes[indexPath.row]
                UserDefaults.standard.downloadEpisode(episode: episode)
                self.showDownloadHightLight()
                APIService.shared.downloadEpisode(episode: episode)
            }
            return [downloadAction]
        } else {
            let downloadedAction = UITableViewRowAction(style: .normal, title: "Has Downloaded") { (_, _) in
            }
            return [downloadedAction]
        }
    }
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
