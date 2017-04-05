//
//
//  Cykas
//
//  Created by Domenico Antonio Tropeano on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//
import UIKit

class SettingViewController: UIViewController {
    
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
        print("bisogna eliminare tutto");
    }
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InserisciGesture"
        {
            let nextdestination = segue.destination as! TutorialViewController
            nextdestination.flag=true
        }
    }
}
