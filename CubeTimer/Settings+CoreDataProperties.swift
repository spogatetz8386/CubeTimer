//
//  Settings+CoreDataProperties.swift
//  
//
//  Created by apcs2 on 11/10/17.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var doesInspect: Bool

}
