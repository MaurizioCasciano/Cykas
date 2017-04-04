//
//  GalleryViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
	UICollectionViewDelegate,
UICollectionViewDataSource {
    
	@IBOutlet var collectionView: UICollectionView!
	var images: [UIImage] = [UIImage]()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}
	
	@IBAction func didImportClick(_ sender: UIBarButtonItem) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		
		let addActionSheet = UIAlertController.init(
			title: "Photo Source",
			message: "Choose a source",
			preferredStyle: UIAlertControllerStyle.init(rawValue: 1)!)
		
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			addActionSheet.addAction(
				UIAlertAction.init(
					title: "Camera",
					style: .default,
					handler: {
						(action: UIAlertAction)in
						imagePickerController.sourceType = .camera
						imagePickerController.cameraCaptureMode = .photo
						imagePickerController.modalPresentationStyle = .fullScreen
						self.present(imagePickerController, animated: true, completion: nil)
				}
				)
			)
		}
		
		if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
			addActionSheet.addAction(
				UIAlertAction.init(
					title: "Photo Library ",
					style: .default,
					handler: {
						(action: UIAlertAction)in
						imagePickerController.sourceType = .photoLibrary
						self.present(imagePickerController, animated: true, completion: nil)
				}
				)
			)
		}
		
		addActionSheet.addAction(UIAlertAction.init(title: "Cancel ", style: .cancel, handler: nil))
		
		self.present(addActionSheet, animated: true, completion: nil)
	}

	/**
	*User picked a photo
	*/
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		
		self.images.append(image)
		
		self.collectionView.reloadData()
		picker.dismiss(animated: true, completion: nil)
		
		let imageURL = info[UIImagePickerControllerReferenceURL] as! URL
		let imageURLs = [imageURL]
		
		//Let's delete it now
		PHPhotoLibrary.shared().performChanges(
			//CHANGE-BLOCk
			{
				let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: imageURLs, options: nil)
				
				PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
		},
			completionHandler: {
				(success, error)in
				NSLog("Finished deleting asset. @", success ? "Success" : "Error")
		})
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	/**
	*Returns the number of cells to create.
	*/
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return self.images.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
		
		cell.layer.borderColor = UIColor.blue.cgColor
		cell.layer.borderWidth = 1
		
		cell.imageView.image = self.images[indexPath.row]
		
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showPhoto"{
			if let selectedIndexPath =
				collectionView.indexPathsForSelectedItems?.first {
				let image = self.images[selectedIndexPath.row]
				let imageVC = segue.destination as! ImageViewController
				imageVC.uiImage = image
			}
		}
	}
}
