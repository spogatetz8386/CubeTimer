//
//  PreviousTimesViewController.swift
//  CubeTimer
//
//  Created by Scott on 9/10/17.
//  Copyright © 2017 apcs2. All rights reserved.
//

import Foundation
import UIKit

class PreviousTimesViewController : UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class SavedTimeCell : UITableViewCell{
    let timeLabel : UILabel = {
        let label = UILabel()
        label.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : label]))
        label.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : label]))
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
