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
//        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        searchBar(searchController.searchBar, textDidChange: "NPR")
    }
    // MARK: - Search Bar implement
    var timer: Timer?
    fileprivate func setupSearchBar() {
        //TBD, why needs this?
//        self.definesPresentationContext = true
        //end
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    //this function is conform to searchbarDelegate and catch the typeText
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        })
    }
    // MARK: - setup header info
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "please enter a search term"
        label.textAlignment = .center
        return label
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }
    // MARK: - setup tableView function
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeController = EpisodesController()
        navigationController?.pushViewController(episodeController, animated: true)
        episodeController.podcast = podcasts[indexPath.row]
    }
    fileprivate func setupTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        //TBD: please check
        tableView.tableFooterView = UIView()
        //end
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
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}
