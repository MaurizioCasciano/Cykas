//
//
//  Cykas
//
//  Created by Domenico Antonio Tropeano on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//
import UIKit
import CoreData
class SettingViewController: UIViewController {
    
    var items = [Notes]()
    var images: [Media] = [Media]()
    
    @IBAction func DeleteFiles(_ sender: UIButton) {
        
        let addActionSheet = UIAlertController.init(
            title: "Elimina Files",
            message: "Vuoi eliminare tutti i files ?",
            preferredStyle: UIAlertControllerStyle.init(rawValue: 1)!)
        

        addActionSheet.addAction(UIAlertAction.init(title: "Cancel ", style: .cancel, handler: nil))

        
        addActionSheet.addAction(UIAlertAction.init(title: "Yes ",style: .default,
                                      handler: {(action: UIAlertAction) in self.DeleteAllFiles()}))
        
        
        
        self.present(addActionSheet, animated: true, completion: nil)
        
    }
    func DeleteAllFiles(){
        NotePersistenceManager.deleteAllItem()
        MediaPersistenceManager.deleteAllItem()
        exit(0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        items =  NotePersistenceManager.fetchData()
        images = MediaPersistenceManager.fetchData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
