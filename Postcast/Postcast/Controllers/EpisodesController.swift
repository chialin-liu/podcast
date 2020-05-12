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
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
