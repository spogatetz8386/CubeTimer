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
        print(CTime.timeFromSeconds(input: 1234.27).getTimeString())
        self.navigationController?.navigationBar.isHidden = true

        self.view.backgroundColor = .white
        self.view.addSubview(timer)
        //self.view.addSubview(scrambleGenerator)
        self.createContraints()
        self.scrambleGenerator.nextScramble()
        self.addSwipeGesture()
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
        
        self.view.addConstraints(horizontalConstraints)
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
    
    static func timeFromSeconds(input: Double) -> CTime{
        var timeInSeconds = input
        let minutes = Int(timeInSeconds / 60)
        timeInSeconds = timeInSeconds.truncatingRemainder(dividingBy: 60.0)
        let seconds = Int(timeInSeconds)
        let tenths = Int(timeInSeconds.truncatingRemainder(dividingBy: 1.0) * 10)
        let hundreths = Int(round(timeInSeconds.truncatingRemainder(dividingBy: 0.1) * 100))
        return CTime(hundreths: hundreths, tenths: tenths, seconds: seconds, minutes: minutes)
    }
    
    func increment(){
        self.hundreths += 10
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
    
    func incrementInspection(){
        for i in 0...9{
            print(i)
            self.increment()
        }
    }
    
    func getTimeString() -> String{
        return "\(minutes):\(seconds).\(tenths)\(hundreths)"
    }
}

class TimerView : UILabel{

    var link = CADisplayLink()

    var initialTime : Double?
    var time = CTime(hundreths: 0, tenths: 0, seconds: 0, minutes: 0)
    var mode = Mode.standby
    let scrambleGenerator = ScrambleGenerator()
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
    
    func inspectionTimer(){
        self.time.incrementInspection()
        self.text = String(self.time.seconds)
        if(self.text == "15"){
            self.timer?.invalidate()
            self.mode = .solving
            link = CADisplayLink(target: self, selector: #selector(startTiming))
            link.add(to: .main, forMode: .defaultRunLoopMode)
            self.time = CTime(hundreths: 0, tenths: 0, seconds: 0, minutes: 0)
            self.backgroundColor = .green
            self.text = "0:0:0"
        }
    }
    
    private func setupVisual(){
        if UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            self.text = "Hold"
        } else {
            self.text = "Hold to Start"
        }
        self.backgroundColor = UIColor(colorLiteralRed: 147/255, green: 188/255, blue: 255/255, alpha: 1)
        self.textAlignment = NSTextAlignment(rawValue: 1)!
        self.font = UIFont(name: "Verdana", size: 48)
        
        self.scrambleGenerator.isUserInteractionEnabled = true
        self.scrambleGenerator.translatesAutoresizingMaskIntoConstraints = false
        self.scrambleGenerator.textAlignment = NSTextAlignment(rawValue: 1)!
        self.scrambleGenerator.nextScramble()
        self.scrambleGenerator.numberOfLines = 2
        self.addSubview(scrambleGenerator)
        
        let contraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[scramble]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scramble" : self.scrambleGenerator])
        let contraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[scramble]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["scramble" : self.scrambleGenerator])
        self.addConstraints(contraintsV)
        self.addConstraints(contraintsH)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.mode == Mode.standby{
            if UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
                self.text = "Release"
            } else {
                self.text = "Release When Ready"
            }
            self.backgroundColor = .red
            self.mode = .holding
        }
        else if self.mode == Mode.solving{
            self.mode = Mode.standby
            self.scrambleGenerator.nextScramble()
            self.link.invalidate()
            self.initialTime = nil
            self.backgroundColor = UIColor(colorLiteralRed: 147/255, green: 188/255, blue: 255/255, alpha: 1)
            self.saveTime(time: self.time)
            self.getTimes()
            self.time = CTime(hundreths: 0, tenths: 0, seconds: 0, minutes: 0)
            if UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
                self.text = "Hold"
            } else {
                self.text = "Hold to Start"
            }
        }
        else if self.mode == .inspecting{
            link = CADisplayLink(target: self, selector: #selector(startTiming))
            self.timer?.invalidate()
            link.add(to: .main, forMode: .defaultRunLoopMode)
            self.time = CTime(hundreths: 0, tenths: 0, seconds: 0, minutes: 0)
            self.mode = .solving
            self.backgroundColor = .green
            self.text = "0:0:0"
        }
    }
    
    func startTiming(link: CADisplayLink){
        if(self.initialTime == nil){
            self.initialTime = link.targetTimestamp
        }
        UIView.animate(withDuration: 0.2) {
            print(CTime.timeFromSeconds(input: link.timestamp - self.initialTime!).getTimeString())
            self.text = CTime.timeFromSeconds(input: link.timestamp - self.initialTime!).getTimeString()
            self.time = CTime.timeFromSeconds(input: link.timestamp - self.initialTime!)
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
        if self.mode == Mode.holding && Setting.current.doesUseInspectionTime == false{
            link = CADisplayLink(target: self, selector: #selector(startTiming))
            link.add(to: .main, forMode: .defaultRunLoopMode)
            self.backgroundColor = .green
            self.text = "0:0:0"
            self.mode = .solving
        }
        else if self.mode == Mode.holding && Setting.current.doesUseInspectionTime{
            self.mode = .inspecting
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerView.inspectionTimer), userInfo: nil, repeats: true)
            self.text = "0"
            print("Start Inspecting")
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
