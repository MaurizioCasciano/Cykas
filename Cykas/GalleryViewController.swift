//
//  GalleryViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation

class GalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
	UICollectionViewDelegate,
UICollectionViewDataSource {
	@IBOutlet var collectionView: UICollectionView!
	var images: [Media] = [Media]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		images = MediaPersistenceManager.fetchData()
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
		
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		images.append(MediaPersistenceManager.newItem(image))
		self.collectionView.reloadData()
		picker.dismiss(animated: true, completion: nil)
            if picker.sourceType == .photoLibrary{
			//Let's delete it now
			PHPhotoLibrary.shared().performChanges( 
				{
                    let imageURL = info[UIImagePickerControllerReferenceURL] as! URL
					let imageURLs = [imageURL]
					let imageAssetToDelete = PHAsset.fetchAssets(withALAssetURLs: imageURLs, options: nil)
					
					PHAssetChangeRequest.deleteAssets(imageAssetToDelete)
				},
				completionHandler: {
					(success, error)in
					NSLog("Finished deleting asset. @", success ? "Success" : "Error")
			})
		}
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
        let CS = CryptoString()
        let data:Data = Encrypter.decrypt(data: images[indexPath.row].binaryDate! as Data, password:CS.cryptoString!)
        print ("Decripto quando Vedo le immagini: \(PersistenceManager.fetchData().description.sha256())")
		cell.imageView.image = UIImage(data:data)
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showPhoto"{
			if let selectedIndexPath =
				collectionView.indexPathsForSelectedItems?.first {
                let CS = CryptoString()
                let data:Data = Encrypter.decrypt(data: images[selectedIndexPath.row].binaryDate! as Data,password:CS.cryptoString!)
                let img  = UIImage(data:data)!
                let imageVC = segue.destination as! ImageViewController
				imageVC.uiImage = img 
            }
		}
	}
}
