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
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    
    var current : Int = 0
    var max : Int = 100
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressLabel.text = "0%"
        self.counter = 0
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Encryption
        
        let data:NSData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "foto"), 1)! as NSData
        let password = "Secret password "
        let hashPass=password.sha512()
        let ciphertext = RNCryptor.encrypt(data: data as Data, withPassword: hashPass)

        
        // Create and add the view to the screen.
        
        // All done!

        

        // Move to a background thread to do some long running work
        for _ in 1...max{
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    _ = try RNCryptor.decrypt(data: ciphertext, withPassword: hashPass)
                    //let finalImage = UIImage(data : originalData as Data)!
                    
                    
                } catch {
                    print(error)
                }
                
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.counter+=1
                    if(self.counter>=100){
                     self.performSegue(withIdentifier: "navigationSegue", sender: nil)
                    }
                }
            }
           
            
        }
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    var counter:Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / Float(max)
            let animated = counter != 0
            
            progressBar.setProgress(fractionalProgress, animated: animated)
            progressLabel.text = ("\(counter/(max/100))%")
        }
    }
    
}
