//
//  PodcastCell.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/11.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class PodcastCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    var podcast: Podcast? {
        didSet {
            trackNameLabel.text = podcast?.trackName
            artistNameLabel.text = podcast?.artistName
            episodeCountLabel.text = "\(podcast?.trackCount ?? 0) Episodes"
            guard let url = URL(string: podcast?.artworkUrl600 ?? "" ) else { return }
            //use sdwebimage instead of URLSession.shared.dataTask
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
