//
//  PlayerDetailViewGestures.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/15.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
extension PlayerDetailView {
    @objc func handleTapMaximize() {
        guard let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        //not pass new episode, just max the detail
        mainTabController.maxmizePlayerDetail(episode: nil)
//        panGesture.isEnabled = false
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
//                gesture.isEnabled = false
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }, completion: nil)
    }
}
