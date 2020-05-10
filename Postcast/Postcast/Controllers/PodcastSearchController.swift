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
//        let url = "https://itunes.apple.com/search?term=\(searchText)"
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil).responseData { (dataResp) in
            if let err = dataResp.error {
                print("Failed to contact url", err)
            }
            guard let data = dataResp.data else {return}
            do {
                let searchResult = try  JSONDecoder().decode(SearchResults.self, from: data)
                self.podcasts = searchResult.results
                self.tableView.reloadData()
            } catch let decodeErr {
                print("Failed to decode", decodeErr)
            }
        }
    }
    // MARK: - setup tableView function
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let podcast = podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.trackName ?? "") \n\(podcast.artistName ?? "")"
        cell.textLabel?.numberOfLines = -1
        cell.backgroundColor = .yellow
        cell.imageView?.image = UIImage(named: "appicon")
        return cell
    }
}
