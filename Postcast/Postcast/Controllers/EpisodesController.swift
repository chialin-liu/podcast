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
    }
    // MARK: - fetchEpisodes
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        //change feedurl to https:
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            switch result {
            case .success(let feed):
                var episodes = [Episode]()
                guard let items = feed.rssFeed?.items else { return }
                for feedItem in items {
                    episodes.append(Episode(feedItem: feedItem))
                }
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch RSS", error)
            }
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
