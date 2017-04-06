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
        MediaPersistenceManager.deleteItem(item: media!)
        MediaPersistenceManager.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Export(_ sender: Any) {
    }
    
	override func viewDidLoad() {
		self.imageView.image = self.uiImage
	}
}
