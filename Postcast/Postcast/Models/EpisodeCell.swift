//
//  EpisodeCell.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/12.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    var episode: Episode? {
        didSet {
            titleLabel.text = episode?.title
            descriptionLabel.text = episode?.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateLabel.text = dateFormatter.string(from: episode?.pubDate ?? Date())
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
}
