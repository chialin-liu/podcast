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
    @IBAction func handleSound(_ sender: UISlider) {
        player.volume = sender.value
    }
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    fileprivate func seekToCurrentTime(delta: Int64) {
        let fifteen = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteen)
        player.seek(to: seekTime)
    }
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBAction func currentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        let seekTimeSeconds = Float64(percentage) * durationSeconds
//        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: 1)
        let seekTime = CMTime(value: CMTimeValue(seekTimeSeconds), timescale: 1)
        player.seek(to: seekTime)
    }
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
            enlargeEpisodeImageView()
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player.pause()
            shrinkEpisodeImageView()
        }
    }
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.8
            self.episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel! {
        didSet {
            episodeLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            let scale: CGFloat = 0.8
            episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    //TBD, don't know why..
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self](time) in
            //player has a reference to self
            //self has a ref to player
            // retain cycle-> to add [weak self] to resolve
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toDisplayString()
            self?.updateCurrentTimeSlider()
        }
    }
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationTimeSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime())
        let percentage = currentTimeSeconds / durationTimeSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        observePlayerCurrentTime()
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        //player has a reference to self
        //self has a ref to player
        // retain cycle-> to add [weak self] to resolve
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            self?.enlargeEpisodeImageView()
        }
    }
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        }, completion: nil)
    }
}
