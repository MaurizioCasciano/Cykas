//
//  NotePersistent.swift
//  ListNote
//
//  Created by Marco Feoli on 03/04/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import CoreData
import CryptoSwift
class NotePersistenceManager {
    
    static let name = "Notes"
    
    static func getContext () -> NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistentContainer.viewContext
    }
    
    static func newEmptyItem() -> Notes {
        let context = getContext()
        let Notes = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Notes
        Notes.name = NSData()
        Notes.data = NSData()
        Notes.content = NSData()
        do{
            try context.save()
        }catch let error as NSError{
            print("Error \(error.code)")
        }
        return Notes
    }
    static func deleteAllItem(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try getContext().execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
    }
    static func deleteItem( item : Notes){
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
    
    static func fetchData() -> [Notes]{
        var items = [Notes]()
        let context = getContext()
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        do{
            try items = context.fetch(fetchRequest)
        }catch let error as NSError{
            print("Errore fetch \(error.code)")
        }
        return items
    }
    
    
}
