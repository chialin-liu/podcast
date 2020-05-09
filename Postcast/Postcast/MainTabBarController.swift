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
    //MARK:- Setup Function
    func setupVC(){
        let favoriteNavVC = generateNavigationVC(with: ViewController(), title: "Favorites", image: UIImage(named: "favorites") ?? UIImage())
            
        let searchNavVC = generateNavigationVC(with: ViewController(), title: "Search", image: UIImage(named: "search") ?? UIImage())
        
        let downloadNavVC = generateNavigationVC(with: ViewController(), title: "Downloads", image: UIImage(named: "downloads") ?? UIImage())
        viewControllers = [favoriteNavVC, searchNavVC, downloadNavVC]
    }
    //MARK:- Helper Function
    fileprivate func generateNavigationVC(with rootVC: UIViewController, title: String, image: UIImage) -> UINavigationController {
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
