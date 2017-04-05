//
//  ImageViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController  {
    
    
    
	@IBOutlet private var imageView: UIImageView!
	var uiImage: UIImage = UIImage()
    var media : Media? = nil
    let CS = CryptoString()
	

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBack"{
                self.navigationController?.isNavigationBarHidden=true
            }
        else if segue.identifier == "goBackDelete"{
            MediaPersistenceManager.deleteItem(item: media!)
            MediaPersistenceManager.saveContext()
            self.navigationController?.isNavigationBarHidden=true
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
    self.performSegue(withIdentifier: "goBack", sender: nil)
    }
    
	override func viewDidLoad() {
		self.imageView.image = self.uiImage
	}
}
