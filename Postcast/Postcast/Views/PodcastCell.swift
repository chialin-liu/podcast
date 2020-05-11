//
//  PodcastCell.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/11.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
class PodcastCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    var podcast: Podcast? {
        didSet {
            trackNameLabel.text = podcast?.trackName
            artistNameLabel.text = podcast?.artistName
        }
    }
}
