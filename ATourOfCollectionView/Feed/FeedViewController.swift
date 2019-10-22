//
//  FeedViewController.swift
//  ATourOfCollectionView
//
//  Created by Calin Calin on 21/09/2019.
//  Copyright © 2019 Calin Radu Calin. All rights reserved.
//

import UIKit

class FeedViewController: UICollectionViewController {
    
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        navigationItem.title = "\(person.name)'s Feed"
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return person.feedImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.image = person.feedImages[indexPath.item]
        return cell
    }
}
