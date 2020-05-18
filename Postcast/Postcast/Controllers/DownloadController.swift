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
        setupObservers()
    }
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    @objc func handleDownloadComplete(notification: Notification) {
        print("Fetch downloaded episode")
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        var index: Int? = 0
        for (idx, item) in episodes.enumerated() {
            if item.title == episodeDownloadComplete.episodeTitle {
                index = idx
            }
        }
        self.episodes[index ?? 0].fileUrl = episodeDownloadComplete.fileUrl
    }
    @objc func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        var index: Int? = 0
        for (idx, item) in episodes.enumerated() {
            if item.title == title {
                index = idx
            }
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: index ?? 0, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.text = "\(Int(progress * 100))%"
        if progress == 1 {
            cell.progressLabel.isHidden = true
        } else {
            cell.progressLabel.isHidden = false
        }
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
        //fix bug?
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        tableView.reloadData()
        //end
        let episode = episodes[indexPath.row]
        if episode.fileUrl != nil {
            UIApplication.mainTabController().maxmizePlayerDetail(episode: episode, playListEpisodes: episodes)
        } else {
            let alertController = UIAlertController(title: "Download has not finished", message: "Play mp3 using internet instead", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                UIApplication.mainTabController().maxmizePlayerDetail(episode: episode, playListEpisodes: self.episodes)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
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
