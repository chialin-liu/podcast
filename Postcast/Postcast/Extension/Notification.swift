//
//  Notification.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/18.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}
