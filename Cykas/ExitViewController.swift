//
//  ExitViewController.swift
//  Cykas
//
//  Created by Antonio Corsuto on 05/04/17.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit

class ExitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Touch on YES to exit", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "YES", style: .default, handler: {(action: UIAlertAction) in exit(0)})
        let CancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        alertController.addAction(CancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
