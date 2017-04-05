//
//  CryptoString.swift
//  Cykas
//
//  Created by ANTONIO ALBERINI on 05/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit
import CoreData

class CryptoString {
        
        public var cryptoString : String?
    
    init() {
        let items = PersistenceManager.fetchData()
        var points = [String]()
        for i in 0...(items.count-1){
            points.append(items[i].point!)
        }
        print("Sto creando il CryptoString : \(points.description.sha256())")
        cryptoString = points.description.sha256()
    }
    
}
