//
//  TemplateGesture+CoreDataProperties.swift
//  Cykas
//
//  Created by ANTONIO ALBERINI on 03/04/2017.
//  Copyright © 2017 Maurizio Casciano. All rights reserved.
//

import Foundation
import CoreData


extension TemplateGesture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemplateGesture> {
        return NSFetchRequest<TemplateGesture>(entityName: "TemplateGesture")
    }

    @NSManaged public var point: String?

}
