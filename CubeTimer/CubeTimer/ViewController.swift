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
    }
}


class navigationCollectionCell : UICollectionViewCell{
    var image : UIImage
    var name : String
    
    init(name : String, image : UIImage, frame : CGRect) {
        self.image = image
        self.name = name
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
