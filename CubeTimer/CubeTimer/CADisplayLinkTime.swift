//
//  CADisplayLinkTime.swift
//  CubeTimer
//
//  Created by apcs2 on 10/31/17.
//  Copyright © 2017 apcs2. All rights reserved.
//

import Foundation
import UIKit

class CADisplayLinkTime{
    var initialTime : Double?
    init() {
        self.initialTime = nil
        let link = CADisplayLink(target: self, selector: #selector(step))
        link.add(to: .main, forMode: .defaultRunLoopMode)
    }
    @objc func step(link : CADisplayLink){
        if(initialTime == nil){
            self.initialTime = link.timestamp
        }
        //print(link.targetTimestamp - initialTime!)
    }
}
