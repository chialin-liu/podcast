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
        self.view.backgroundColor = .green
        let favoriteVC = ViewController()
        viewControllers = [favoriteVC]
    }
}
