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
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(navigationCollectionCell.self, forCellWithReuseIdentifier: "navCell")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = navigationCollectionCell(name: "Test", frame: nil)
        collectionView.dequeueReusableCell(withReuseIdentifier: "navCell", for: indexPath)
    }
}


class navigationCollectionCell : UICollectionViewCell{
    //var image : UIImage?
    var name : String
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigationCollectionCell.onTap))
    
    init(name : String, frame : CGRect) {
        //self.image = image
        self.name = name
        super.init(frame: frame)
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func onTap(){
        print("\(self.name) tapped.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
