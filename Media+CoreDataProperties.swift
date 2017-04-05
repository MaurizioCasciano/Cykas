//
//  Media+CoreDataProperties.swift
//  Cykas
//
//  Created by ANTONIO ALBERINI on 05/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import Foundation
import CoreData


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var binaryDate: NSData?

}
