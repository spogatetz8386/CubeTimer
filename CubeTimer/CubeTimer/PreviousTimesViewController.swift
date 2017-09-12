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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SavedTimeCell.self, forCellReuseIdentifier: identifier)
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : timeLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : timeLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
