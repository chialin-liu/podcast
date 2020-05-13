//
//  PlayerDetailsView.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/12.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import AVKit
import AVFoundation
class PlayerDetailView: UIView {
    var episode: Episode! {
        didSet {
            episodeLabel.text = episode.title
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            episodeImageView.sd_setImage(with: url, completed: nil)
            authorLabel.text = episode.author
            playEpisode()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    fileprivate func playEpisode() {
        guard let url = URL(string: episode.streamUrl.toSecureHTTPS()) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    let player: AVPlayer = {
        let avplayer = AVPlayer()
        avplayer.automaticallyWaitsToMinimizeStalling = false
        return avplayer
    }()
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player.pause()
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel! {
        didSet {
            episodeLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
}
