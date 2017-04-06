//
//  ImageViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UINavigationControllerDelegate {
    
    
    
	@IBOutlet private var imageView: UIImageView!
	var uiImage: UIImage = UIImage()
    var media : Media? = nil
    let CS = CryptoString()
	
    @IBAction func DeleteImage(_ sender: Any) {
        let addActionSheet = UIAlertController.init(
            title: "Delete file",
            message: "Do you want delete this file?",
            preferredStyle: UIAlertControllerStyle.init(rawValue: 1)!)
        
        
        addActionSheet.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        
        
        addActionSheet.addAction(UIAlertAction.init(title: "Yes ",style: .default,
                                                    handler: {(action: UIAlertAction) in
                                                        MediaPersistenceManager.deleteItem(item: self.media!)
                                                        MediaPersistenceManager.saveContext()
                                                        self.navigationController?.popViewController(animated: true)
        }))
        
         self.present(addActionSheet, animated: true, completion: nil)

    }
    @IBAction func Export(_ sender: Any) {
    }
    
	override func viewDidLoad() {
		self.imageView.image = self.uiImage
	}
}
