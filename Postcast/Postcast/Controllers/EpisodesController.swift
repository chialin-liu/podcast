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
    var episodes = [
        Episode(title: "First"),
        Episode(title: "Second")
    ]
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
                    episodes.append(Episode(title: feedItem.title ?? ""))
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        //TBD: to remove lines shows below
        tableView.tableFooterView = UIView()
    }
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.title
        return cell
    }
}
