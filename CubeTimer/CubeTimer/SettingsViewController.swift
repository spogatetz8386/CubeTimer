//
//  SettingsViewController.swift
//  CubeTimer
//
//  Created by apcs2 on 10/24/17.
//  Copyright © 2017 apcs2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Setting{
    static var current = Setting()
    var doesUseInspectionTime : Bool = false
}

class SettingsController : UIViewController{
    let inspectToggle = ToggleButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100), size: 40)

    let inspectLabel = UILabel()
    let swipe = UISwipeGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 147/255, green: 188/255, blue: 255/255, alpha: 1)
        setupButtons()
        setupLabels()
        swipe.addTarget(self, action: #selector(onSwipe))
        swipe.numberOfTouchesRequired = 2
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
        self.view.addSubview(inspectToggle)
        self.view.addSubview(inspectLabel)
    }
    func setupButtons(){
        let x = UIScreen.main.bounds.width / 2 - inspectToggle.frame.width / 2
        let y = inspectToggle.frame.height / 2 + 20
        let width = inspectToggle.frame.width
        let height = inspectToggle.frame.height
        inspectToggle.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    
    func onSwipe(){
        guard let nav = self.navigationController else { return }
        nav.popViewController(animated: true)
    }
    
    func setupLabels(){
        let x = 0
        let y = inspectToggle.frame.maxY
        inspectLabel.text = "Inspection Period"
        inspectLabel.font = UIFont(name: "Verdana", size: 24)
        inspectLabel.textColor = .black
        inspectLabel.textAlignment = NSTextAlignment(rawValue: 1)!
        let width = UIScreen.main.bounds.width
        let height = 50
        inspectLabel.frame = CGRect(x: CGFloat(x), y: y, width: width, height: CGFloat(height))
    }
}
