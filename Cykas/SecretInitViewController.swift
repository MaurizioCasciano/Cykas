//
//  SecretInitViewController.swift
//  Cykas
//
//  Created by Domenico Antonio Tropeano on 02/04/2017.
//  Copyright © 2017 Maurizio Casciano. All rights reserved.
//

import UIKit
import CryptoSwift
import RNCryptor

class SecretInitViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Encryption
        
        let data:NSData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "foto"), 1)! as NSData
        let password = "Secret password "
        let hashPass=password.sha512()
        let ciphertext = RNCryptor.encrypt(data: data as Data, withPassword: hashPass)
        
        
        // Create and add the view to the screen.
        let progressHUD = ProgressHUD(text: "Saving Photo")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        // All done!
        
        
        for m in 1...100{
            
            
            do {
                let originalData = try RNCryptor.decrypt(data: ciphertext, withPassword: hashPass)
                //let finalImage = UIImage(data : originalData as Data)!
                
                
            } catch {
                print(error)
            }
        }
        progressHUD.hide()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
}
