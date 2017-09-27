//
//  TimerViewController.swift
//  CubeTimer
//
//  Created by Scott on 9/8/17.
//  Copyright © 2017 apcs2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TimerViewController : UIViewController{
    let timer = TimerView()
    var initialX : CGFloat = CGFloat()
    let swipe = UISwipeGestureRecognizer()
    let scrambleGenerator = ScrambleGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(timer)
        self.createContraints()
        self.view.addSubview(scrambleGenerator)
        self.scrambleGenerator.nextScramble()
        self.addSwipeGesture()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addSwipeGesture(){
        self.swipe.addTarget(self, action: #selector(TimerViewController.onSwipe))
        self.swipe.direction = .right
        self.swipe.numberOfTouchesRequired = 2
        self.timer.isUserInteractionEnabled = true
        self.timer.addGestureRecognizer(self.swipe)
    }

    func onSwipe(){
        guard let nav = navigationController else { return }
        nav.popViewController(animated: true)
    }
    
    func createContraints(){
        self.timer.translatesAutoresizingMaskIntoConstraints = false
        self.scrambleGenerator.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[timer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["timer" : timer])

        let verticleContraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[timer]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["timer" : timer])
        
        //let genConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scramble(30)]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scramble" : scrambleGenerator])
        
        self.view.addConstraints(horizontalConstraints)
        //self.view.addConstraints(genConstraints)
        self.view.addConstraints(verticleContraints)
    }
}

enum Mode{
    case solving, holding, inspecting, standby
}

class CTime {
    var hundreths : Int = Int()
    var tenths : Int = Int()
    var seconds : Int = Int()
    var minutes : Int = Int()
    
    init(hundreths : Int, tenths : Int, seconds : Int, minutes : Int) {
        self.hundreths = hundreths
        self.tenths = tenths
        self.seconds = seconds
        self.minutes = minutes
    }
    
    func increment(){
        self.hundreths += 1
        if hundreths == 10{
            self.hundreths = 0
            self.tenths += 1
        }
        if self.tenths == 10{
            self.tenths = 0
            self.seconds += 1
        }
        if self.seconds == 60{
            self.seconds = 0
            self.minutes += 1
        }
    }
    
    func getTimeString() -> String{
        return "\(minutes):\(seconds).\(tenths)\(hundreths)"
    }
}

class TimerView : UILabel{
    var time = CTime(hundreths: 0, tenths: 0, seconds: 0, minutes: 0)
    var mode = Mode.standby
    var timer : Timer?
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return (appDelegate.managedObjectContext)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupVisual()
    }

    func onTick(){
        self.time.increment()
        self.text = self.time.getTimeString()
    }
    
    private func setupVisual(){
        self.text = "Hold to start"
        self.backgroundColor = UIColor(colorLiteralRed: 147/255, green: 188/255, blue: 255/255, alpha: 1)
        self.textAlignment = NSTextAlignment(rawValue: 1)!
        self.font = UIFont(name: "Verdana", size: 48)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.mode == Mode.standby{
            self.text = "Release When Ready"
            self.backgroundColor = .red
            self.mode = .holding
        }
        else if self.mode == Mode.solving{
            self.mode = Mode.standby
            self.timer?.invalidate()
            self.backgroundColor = UIColor(colorLiteralRed: 147/255, green: 188/255, blue: 255/255, alpha: 1)
            self.saveTime(time: self.time)
            self.getTimes()
            self.time = CTime(hundreths: 0, tenths: 0, seconds: 0, minutes: 0)
            self.text = "Hold When Ready"
        }
    }
    
    func saveTime(time : CTime){
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Time", in: context)
        let newTime = NSManagedObject(entity: entity!, insertInto: context)
        
        newTime.setValue(time.hundreths, forKey: "hundreth")
        newTime.setValue(time.tenths, forKey: "tenth")
        newTime.setValue(time.seconds, forKey: "second")
        newTime.setValue(time.minutes, forKey: "minute")
        
        do{
            try context.save()
        } catch{
            print("Error saving time!")
        }
    }
    
    func getTimes(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        do{
            let results = try getContext().fetch(request)
            print("Results: \(results.count)")
        } catch{
            print("Error Fetching")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.mode == Mode.holding{
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerView.onTick), userInfo: nil, repeats: true)
            self.backgroundColor = .green
            self.text = "0:0:0"
            self.mode = .solving
        }


    }
    
    let moc = (UIApplication.shared.delegate as! AppDelegate)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScrambleGenerator : UILabel{
    let validMoves = ["U", "D", "R", "L", "B", "F", "U'", "D'", "R'", "L'", "B'", "F'", "U2", "D2", "R2", "L2", "B2", "F2"]
    var length : Int = 20
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextScramble(){
        var scramble = [String]()
        for _ in 0...length - 1{
            let random = arc4random_uniform(UInt32(Int32(validMoves.count)))
            scramble.append(validMoves[Int(random)])
        }
        self.text = scramble.joined(separator: " ")
    }
}
