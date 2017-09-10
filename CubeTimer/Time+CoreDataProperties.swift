//
//  Time+CoreDataProperties.swift
//  
//
//  Created by Scott on 9/10/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time");
    }

    @NSManaged public var hundreth: Int16
    @NSManaged public var tenth: Int16
    @NSManaged public var second: Int16
    @NSManaged public var minute: Int16

}
