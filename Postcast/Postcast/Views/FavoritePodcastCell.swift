//
//  FavoritePodcastCell.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/17.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
class FavoritePodcastCell: UICollectionViewCell {
    let imageView = UIImageView(image: UIImage(named: "appicon"))
    let nameLabel = UILabel()
    let artistLabel = UILabel()
    fileprivate func styleUI() {
        nameLabel.text = "Yorick"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        artistLabel.font = UIFont.systemFont(ofSize: 14)
        artistLabel.textColor = .lightGray
        artistLabel.text = "Chares"
        
    }
    
    fileprivate func setupStackView() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistLabel])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        styleUI()
        setupStackView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
