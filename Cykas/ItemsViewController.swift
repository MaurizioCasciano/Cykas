//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController {
        var items = [Notes]()
        
        @IBAction func AddButton(_ sender: UIBarButtonItem) {
            let index = IndexPath(row:(items.count - 1) , section : 0)
            tableView.insertRows(at: [index], with: .automatic)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            items =  NotePersistenceManager.fetchData()
            self.navigationItem.leftBarButtonItem = self.editButtonItem
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellItem", for: indexPath) as! ItemCell
            let item = items[indexPath.row]
            let CS = CryptoString()
            cell.nameLabel.text = String(data:Encrypter.decrypt(data: item.name! as Data, password:CS.cryptoString!)  as Data, encoding: .utf8)
            cell.contentLabel.text = String(data:Encrypter.decrypt(data: item.content! as Data, password: CS.cryptoString!)  as Data, encoding: .utf8)
            cell.valueLabel.text = String(data:Encrypter.decrypt(data: item.data! as Data, password: CS.cryptoString!)  as Data, encoding: .utf8)
            return cell
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let item = items[indexPath.row]
                NotePersistenceManager.deleteItem(item: item)
                items.remove(at: indexPath.row)
                NotePersistenceManager.saveContext()
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segue.identifier {
            case "showItem"? :
                let currentrow = tableView.indexPathForSelectedRow?.row
                let currentitem = items[currentrow!]
                let destinationview = segue.destination as! DetailViewController
                destinationview.item = currentitem
                
            case "addNewItem"? :
                items.append(NotePersistenceManager.newEmptyItem())
                NotePersistenceManager.saveContext()
                let currentitem = items[items.count - 1]
                let destinationview = segue.destination as! DetailViewController
                destinationview.item = currentitem
            default: print(#function)
            }
        }
        
}

