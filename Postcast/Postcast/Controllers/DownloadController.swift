//
//  DownloadController.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/17.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
class DownloadController: UITableViewController {
    let cellId = "cellId"
    var episodes = UserDefaults.standard.fetchDownloadedEpisodes()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        tableView.reloadData()
        UIApplication.mainTabController().viewControllers?[2].tabBarItem.badgeValue = nil
    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let episode = self.episodes[indexPath.row]
//        episodes.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        UserDefaults.standard.deleteEpisode(episode: episode)
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        UIApplication.mainTabController().maxmizePlayerDetail(episode: episode, playListEpisodes: episodes)
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            let deleteEpisode = self.episodes[indexPath.row]
//            print("delete episode: \(deleteEpisode.title)")
            self.episodes.remove(at: indexPath.row)
            UserDefaults.standard.deleteEpisode(episode: deleteEpisode)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EpisodeCell else { return EpisodeCell() }
        cell.episode = episodes[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
