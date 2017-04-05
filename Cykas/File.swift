//
//  File.swift
//  Cykas
//
//  Created by Domenico Antonio Tropeano on 05/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//
import UIKit
extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
