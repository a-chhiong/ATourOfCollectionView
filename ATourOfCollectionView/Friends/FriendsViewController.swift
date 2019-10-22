//
//  FriendsViewController.swift
//  ATourOfCollectionView
//
//  Created by Calin Calin on 21/09/2019.
//  Copyright © 2019 Calin Radu Calin. All rights reserved.
//
//  Modified by T.C. Lee on 22.10.2019. (animation part)
//

import UIKit

class FriendsViewController: UIViewController {
    
    static let allImages: [UIImage] = (1...15).compactMap { UIImage(named: "beach\($0)") }
    
    private let demoPeople: [Person] = [
        Person(name: "Steve",
               image: #imageLiteral(resourceName: "person1.jpg"),
               lastUpdate: Calendar.current.date(byAdding: .hour, value: -1, to: Date()),
               feedImages: allImages,
               isUpdated: false),
        Person(name: "Mohammed",
               image: #imageLiteral(resourceName: "person2.jpg"),
               lastUpdate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
               feedImages: Array(allImages.prefix(upTo: 14)),
               isUpdated: false),
        Person(name: "Samir",
               image: #imageLiteral(resourceName: "person3.jpg"),
               lastUpdate: Calendar.current.date(byAdding: .month, value: -1, to: Date()),
               feedImages: Array(allImages.prefix(upTo: 13)),
               isUpdated: false),
        Person(name: "Priyanka",
               image: #imageLiteral(resourceName: "person4.jpg"),
               lastUpdate: Calendar.current.date(byAdding: .year, value: -1, to: Date()),
               feedImages: Array(allImages.prefix(upTo: 12)),
               isUpdated: false)
    ]
    
    private var people: [Person] = []
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        
        let imageSize: CGFloat = 30
        let customButton = UIButton(type: .custom)
        customButton.layer.masksToBounds = true
        customButton.layer.cornerRadius = imageSize/2
        customButton.setImage(#imageLiteral(resourceName: "person5.jpg"), for: .normal)
        
        customButton.addTarget(self, action: #selector(onClickLeftBarButton(sender:)), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: customButton)
        
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        return barButtonItem
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        
        let barButtonItem = UIBarButtonItem()
        
        barButtonItem.title = "EDIT"
        barButtonItem.target = self
        barButtonItem.action = #selector(onClickRightBarButton(sender:))
        
        return barButtonItem
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: ColumnFlowLayout())
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(UINib(nibName: PersonCell.identifier, bundle: nil), forCellWithReuseIdentifier: PersonCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadPeople()
        
        view.addSubview(collectionView)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc func onClickLeftBarButton(sender: UIBarButtonItem){
        print("leftBarButtonClick: reload data")
        
        reloadPeople()
        collectionView.reloadData()
    }
    
    @objc func onClickRightBarButton(sender: UIBarButtonItem){
        print("rightBarButtonClick: perform animation")
        
        performUpdate()
    }
    
    private func performUpdate() {
        
        if(people.count != 4){
            return
        }
        
        // Perform reloads first
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                people[3].isUpdated = true
                collectionView.reloadItems(at: [IndexPath(item: 3, section: 0)])
            })
        }
        
        collectionView.performBatchUpdates({
            //  We have 2 updates:
            //  - delete item at index 2
            //  - move item at index 3 to index 0
            
            //  becomes
            
            //  delete item at index 2
            //  delete item at index 3
            //  insert item from index 3 at index 0
            
            let movedPerson = people[3]
            people.remove(at: 3)
            people.remove(at: 2)
            
            people.insert(movedPerson, at: 0)
            
            //  update Collection View
            collectionView.deleteItems(at: [IndexPath(item: 2, section :0)])
            collectionView.moveItem(at: IndexPath(item: 3, section: 0), to: IndexPath(item: 0, section: 0))
            
        })
    }
    
    private func reloadPeople(){
        
        if(people.count > 0){
            people.removeAll();
        }
        
        people.append(contentsOf: demoPeople)
    }
    
}

extension FriendsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.identifier, for: indexPath) as! PersonCell
        cell.person = people[indexPath.item]
        return cell
    }
}

extension FriendsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedViewController = FeedViewController(collectionViewLayout: MosaicLayout())
        feedViewController.person = people[indexPath.item]
        navigationController?.pushViewController(feedViewController, animated: true)
    }
}

