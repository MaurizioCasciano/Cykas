//
//  MediaPersistenceManager.swift
//  Cykas
//
//  Created by ANTONIO ALBERINI on 05/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit
import CoreData

class MediaPersistenceManager {
    
    static let name = "Media"
    
    static func getContext () -> NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistentContainer.viewContext
    }
    
    static func newItem(_ img : UIImage) -> Media {
        let context = getContext()
        let image = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Media
        let picture = UIImageJPEGRepresentation(img , 1)!
        let CS  = CryptoString()
        print(picture)
        image.binaryDate = Encrypter.encrypt(data: picture , password: CS.cryptoString!) as NSData
        do{
            try context.save()
        }catch let error as NSError{
            print("Error \(error.code)")
        }
        return image
    }
    
    static func deleteItem( item : Media){
        let context = getContext()
        context.delete(item)
    }
    
    static func saveContext()
    {
        let context = getContext()
        do{
            try context.save()
        }catch let error as NSError{
            print("Errore di salvataggio \(error.code)")
        }
    }
    
    static func fetchData() -> [Media]{
        var items = [Media]()
        let context = getContext()
        let fetchRequest = NSFetchRequest<Media>(entityName: "Media")
        do{
            try items = context.fetch(fetchRequest)
        }catch let error as NSError{
            print("Errore fetch \(error.code)")
        }
        return items
    }
}
