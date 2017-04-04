//
//  ImageViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
	@IBOutlet private var imageView: UIImageView!
	var uiImage: UIImage = UIImage()
	
	override func viewDidLoad() {
		self.imageView.image = self.uiImage
	}
}
