//
//  ToggleButton.swift
//  ToggleViewPod
//
//  Created by apcs2 on 10/10/17.
//  Copyright © 2017 apcs2. All rights reserved.
//

import Foundation
import UIKit

class ToggleButton: UIView {
    private let hConst = 1
    private let wConst = 3
    private let duration = 1
    let activeColor : UIColor = .green
    let inactiveColor : UIColor = .red
    var active : Bool = false
    let circleView = UIView()
    init(frame: CGRect, size: Int) {
        super.init(frame: frame)
        self.backgroundColor = self.inactiveColor
        self.setSize(size: size)
        self.setupCircleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSize(size: Int){
        //Aspect ration of the button
        self.frame = CGRect(x: Int(self.frame.minX), y: Int(self.frame.minY), width: size * wConst, height: size * hConst)
        self.layer.cornerRadius = CGFloat(size / 2)
    }
    
    private func setupCircleView(){
        print("Creating circle view")
        let diameter = self.frame.height * 0.8
        circleView.backgroundColor = .blue
        circleView.frame = CGRect(x: CGFloat(wConst * 2), y: self.frame.height * 0.1, width: diameter, height: diameter)
        circleView.layer.cornerRadius = diameter / 2
        self.addSubview(circleView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //move circleView
        if(!active){
            print("set to true")
            self.active = true
            Setting.current.doesUseInspectionTime = true //Possibly erase
            UIView.animate(withDuration: TimeInterval(duration)) {
                self.circleView.center = CGPoint(x: Int(self.frame.width) - Int(self.circleView.frame.width / 2) - Int(self.wConst * 2), y: Int(self.frame.height / 2))
                self.backgroundColor = self.activeColor
            }
 
        } else {
            self.active = false
            print("set to false")
            Setting.current.doesUseInspectionTime = false //possibly delete
            UIView.animate(withDuration: TimeInterval(duration)) {
                self.circleView.center = CGPoint(x: CGFloat(self.wConst * 2) + self.circleView.frame.width / 2, y: self.frame.height / 2)
                self.backgroundColor = self.inactiveColor
            }
        }
    }
}
