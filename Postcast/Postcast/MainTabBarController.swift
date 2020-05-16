//
//  MainTabBarController.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/9.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .purple
//        tabBar.backgroundColor = .yellow
        setupVC()
        setupPlayerDetailView()
//        perform(#selector(maxmizePlayerDetail), with: nil, afterDelay: 1)
    }
    @objc func minimizePlayerDetail() {
        maxTopAnchorContraint.isActive = false
        minTopAnchorContraint.isActive = true
        bottomAnchorContraint.constant = view.frame.height
        self.tabBar.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
//            self.tabBar.transform = .identity
            self.playerDetailView.maximizedStackView.alpha = 0
            self.playerDetailView.miniPlayerView.alpha = 1
        }, completion: nil)
    }
    func maxmizePlayerDetail(episode: Episode?, playListEpisodes: [Episode] = []) {
        minTopAnchorContraint.isActive = false
        maxTopAnchorContraint.isActive = true
        maxTopAnchorContraint.constant = 0
        bottomAnchorContraint.constant = 0
        //use if check means, playDetailView's episode is !, if episode is nil->crash
        if episode != nil {
            playerDetailView.episode = episode
        }
        playerDetailView.playListEpisodes = playListEpisodes
        self.tabBar.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
//            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.playerDetailView.maximizedStackView.alpha = 1
            self.playerDetailView.miniPlayerView.alpha = 0
        }, completion: nil)
    }
    var maxTopAnchorContraint: NSLayoutConstraint!
    var minTopAnchorContraint: NSLayoutConstraint!
    var bottomAnchorContraint: NSLayoutConstraint!
    let playerDetailView = PlayerDetailView.initFromNib()
    fileprivate func setupPlayerDetailView() {
//        self.view.addSubview(playerDetailView)
        self.view.insertSubview(playerDetailView, belowSubview: tabBar)
//        playerDetailView.backgroundColor = .red
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        maxTopAnchorContraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maxTopAnchorContraint.isActive = true
        minTopAnchorContraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minTopAnchorContraint.isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomAnchorContraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorContraint.isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    // MARK: - Setup Function
    func setupVC() {
        let favoriteController = FavoritesController(collectionViewLayout: UICollectionViewFlowLayout())
        let fVC = genVC(with: favoriteController, title: "Favorites", image: UIImage(named: "favorites") ?? UIImage())
        let sVC = genVC(with: PodcastSearchController(), title: "Search", image: UIImage(named: "search") ?? UIImage())
        let dVC = genVC(with: ViewController(), title: "Downloads", image: UIImage(named: "downloads") ?? UIImage())
        viewControllers = [sVC, fVC, dVC]
    }
    // MARK: - Helper Function
    fileprivate func genVC(with rootVC: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.prefersLargeTitles = true
        //Below will fail the code presentation
//        navVC.navigationItem.title = title
        //end
        rootVC.navigationItem.title = title
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        return navVC
    }
}
