//
//  Notes+CoreDataProperties.swift
//  Cykas
//
//  Created by Marco Feoli on 05/04/17.
//  Copyright © 2017 ALBA. All rights reserved.
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var content: NSData?
    @NSManaged public var data: NSData?
    @NSManaged public var name: NSData?

}
