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
        setupVC()
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
