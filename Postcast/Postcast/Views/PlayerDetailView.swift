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
            miniTitleLabel.text = episode.title
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            episodeImageView.sd_setImage(with: url, completed: nil)
            miniEpisodeImageView.sd_setImage(with: url, completed: nil)
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
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
            enlargeEpisodeImageView()
        } else {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
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
    static func initFromNib() -> PlayerDetailView {
        guard let playerDetailView = Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as? PlayerDetailView else { return PlayerDetailView() }
        return playerDetailView
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
    @objc func handleTapMaximize() {
        guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        //not pass new episode, just max the detail
        mainTabController.maxmizePlayerDetail(episode: nil)
        panGesture.isEnabled = false
    }
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.maximizedStackView.alpha = -translation.y / 200
    }
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabController.maxmizePlayerDetail(episode: nil)
                gesture.isEnabled = false
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }, completion: nil)
    }
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    var panGesture: UIPanGestureRecognizer!
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleTapMaximize))
        swipe.direction = .up
//        addGestureRecognizer(swipe)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
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
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBAction func handleDismiss(_ sender: Any) {
//        self.removeFromSuperview()
//        let mainTabController = MainTabBarController()
        guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabController.minimizePlayerDetail()
        panGesture.isEnabled = true
    }
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        }, completion: nil)
    }
}
