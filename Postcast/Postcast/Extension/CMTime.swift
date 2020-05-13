//
//  CMTime.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/13.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    func toDisplayString() -> String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
//        print("total seconds", totalSeconds)
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}
