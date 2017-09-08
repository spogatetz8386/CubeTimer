//
//  ViewController.swift
//  CubeTimer
//
//  Created by apcs2 on 9/6/17.
//  Copyright © 2017 apcs2. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        guard let collectionView = self.collectionView else { return }
        collectionView.delegate = self
        collectionView.frame = UIScreen.main.bounds
        collectionView.dataSource = self
        collectionView.backgroundColor = .blue
        collectionView.register(navigationCollectionCell.self, forCellWithReuseIdentifier: "navCell")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("Number of sections")
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "navCell", for: indexPath) as! navigationCollectionCell
        cell.backgroundColor = .red

        return cell
    }
}


class navigationCollectionCell : UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("creted")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
