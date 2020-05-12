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
class PlayerDetailView: UIView {
    var episode: Episode! {
        didSet {
            episodeLabel.text = episode.title
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
}
