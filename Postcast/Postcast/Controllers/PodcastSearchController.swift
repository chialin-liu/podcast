//
//  PodcastSearchController.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/9.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
//conform to UISearchBarDelegate
class PodcastSearchController: UITableViewController, UISearchBarDelegate {
    var podcasts = [Podcast]()
    let cellId = "cellId"
    //uisearch controller
    //TBD, why it needs to choose argument searchResultController?
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    // MARK: - Search Bar implement
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    //this function is conform to searchbarDelegate and catch the typeText
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
    }
    // MARK: - setup tableView function
    fileprivate func setupTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PodcastCell else { return UITableViewCell() }
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
//        cell.textLabel?.text = "\(podcast.trackName ?? "") \n\(podcast.artistName ?? "")"
//        cell.textLabel?.numberOfLines = -1
//        cell.backgroundColor = .yellow
//        cell.imageView?.image = UIImage(named: "appicon")
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}
