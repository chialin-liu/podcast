//
//  FavoritesController.swift
//  Postcast
//
//  Created by Chialin Liu on 2020/5/16.
//  Copyright © 2020 Chialin Liu. All rights reserved.
//

import Foundation
import UIKit
class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var podcasts = UserDefaults.standard.fetchSavedPodcasts()
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
//        print("Long press")
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }
        let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            self.podcasts.remove(at: selectedIndexPath.item)
            self.collectionView.deleteItems(at: [selectedIndexPath])
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FavoritePodcastCell else { return UICollectionViewCell() }
        cell.podcast = podcasts[indexPath.item]
        return cell
    }
}
