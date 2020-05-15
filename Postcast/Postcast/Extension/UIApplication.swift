//
//  UIApplication.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/15.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
extension UIApplication {
    static func mainTabController() -> MainTabBarController {
        guard let controller = shared.keyWindow?.rootViewController as? MainTabBarController else { return MainTabBarController() }
        return controller
    }
}
