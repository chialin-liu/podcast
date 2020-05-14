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
        tabBar.backgroundColor = .yellow
        setupVC()
        setupPlayerDetailView()
        perform(#selector(maxmizePlayerDetail), with: nil, afterDelay: 1)
    }
    @objc func minimizePlayerDetail() {
        maxTopAnchorContraint.isActive = false
        minTopAnchorContraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @objc func maxmizePlayerDetail() {
        maxTopAnchorContraint.isActive = true
        maxTopAnchorContraint.constant = 0
        minTopAnchorContraint.isActive = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    var maxTopAnchorContraint: NSLayoutConstraint!
    var minTopAnchorContraint: NSLayoutConstraint!
    fileprivate func setupPlayerDetailView() {
        let playerDetailView = PlayerDetailView.initFromNib()
//        self.view.addSubview(playerDetailView)
        self.view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.backgroundColor = .red
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        maxTopAnchorContraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maxTopAnchorContraint.isActive = true
        minTopAnchorContraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minTopAnchorContraint.isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    // MARK: - Setup Function
    func setupVC() {
        let fVC = genVC(with: ViewController(), title: "Favorites", image: UIImage(named: "favorites") ?? UIImage())
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
