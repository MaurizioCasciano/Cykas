//
//  Notes+CoreDataProperties.swift
//  Cykas
//
//  Created by ANTONIO ALBERINI on 05/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var content: String?
    @NSManaged public var data: NSDate?
    @NSManaged public var name: String?

}
