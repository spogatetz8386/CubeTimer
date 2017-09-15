//
//  PreviousTimesViewController.swift
//  CubeTimer
//
//  Created by Scott on 9/10/17.
//  Copyright © 2017 apcs2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PreviousTimesViewController : UITableViewController{
    let identifier = "timeCell"
    let swipe = UISwipeGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGesture()
        tableView.register(SavedTimeCell.self, forCellReuseIdentifier: identifier)
    }
    
    func setupGesture(){
        self.swipe.addTarget(self, action: #selector(PreviousTimesViewController.onSwipe))
        self.swipe.direction = .right
        self.swipe.numberOfTouchesRequired = 2
        self.tableView.isUserInteractionEnabled = true
        self.tableView.addGestureRecognizer(self.swipe)
    }
    
    func onSwipe(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext!
    }
    
    func getTimes() -> [Any]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        do{
            let results = try getContext().fetch(request)

            return results
        }
        catch {
            print("Error Fetching")
        }
        return ["Error"]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getTimes().count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SavedTimeCell
        let newTime = getTimes()[indexPath.row] as! NSManagedObject
        let minute = newTime.value(forKey: "minute")
        let second = newTime.value(forKey: "second")
        let tenth = newTime.value(forKey: "tenth")
        let hundreth = newTime.value(forKey: "hundreth")
        let text = "\(minute ?? 0):\(second ?? 0).\(tenth ?? 0)\(hundreth ?? 0)"
        cell.timeLabel.text = text
        return cell
    }
}

class SavedTimeCell : UITableViewCell{
    let timeLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment(rawValue: 1)!
        label.font = UIFont(name: "Verdana", size: 48)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(colorLiteralRed: 147/255, green: 188/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : timeLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : timeLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
