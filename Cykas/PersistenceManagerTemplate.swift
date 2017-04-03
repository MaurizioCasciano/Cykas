//
//  PersistenceManager.swift
//  ListaDellaSpesa
//
//  Created by ANTONIO ALBERINI on 28/03/2017.
//  Copyright © 2017 ANTONIO ALBERINI. All rights reserved.
//

import UIKit
import CoreData
class PersistenceManager {
    
static let name = "TemplateGesture"
    
    static func getContext () -> NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistentContainer.viewContext
    }
    
    static func newItem(_ point : CGPoint) -> TemplateGesture {
        let context = getContext()
        let stringItem = NSStringFromCGPoint(point)
        let item = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! TemplateGesture
        item.point = stringItem
        do{
            try context.save()
        }catch let error as NSError{
            print("Error \(error.code)")
        }
        return item
    }
    
    static func deleteItem( item : TemplateGesture){
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
    
    static func fetchData() -> [TemplateGesture]{
        var items = [TemplateGesture]()
        let context = getContext()
        let fetchRequest = NSFetchRequest<TemplateGesture>(entityName: "TemplateGesture")
        do{
            try items = context.fetch(fetchRequest)
        }catch let error as NSError{
            print("Errore fetch \(error.code)")
        }
        return items
    }


}
