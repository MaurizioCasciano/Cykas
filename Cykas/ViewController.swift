//
//  ViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 29/03/2017.
//  Copyright © 2017 Maurizio Casciano. All rights reserved.
//

import UIKit
import AVFoundation
import PennyPincher
import LocalAuthentication
import CryptoSwift

class ViewController: UIViewController, UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate{

     private let pennyPincherGestureRecognizer = PennyPincherGestureRecognizer()
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var gestureLabel: UILabel!
   
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var gestureView: GestureView!
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var templateTextField: UITextField!
  
	
	var QRCODEONLY = true
	
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

	override func viewDidLoad() {
		super.viewDidLoad()
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
		
		//Now start code for secrets
		//********************************************************************************************
		//********************************************************************************************
		//********************************************************************************************
		//********************************************************************************************
		//********************************************************************************************
		//********************************************************************************************
		//********************************************************************************************
		
		pennyPincherGestureRecognizer.enableMultipleStrokes = true
		pennyPincherGestureRecognizer.allowedTimeBetweenMultipleStrokes = 0.2
		pennyPincherGestureRecognizer.cancelsTouchesInView = false
		pennyPincherGestureRecognizer.addTarget(self, action: #selector(didRecognize(_:)))
		
		gestureView.addGestureRecognizer(pennyPincherGestureRecognizer)
		
		if(QRCODEONLY){
			let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
			
			do {
				// Get an instance of the AVCaptureDeviceInput class using the previous device object.
				let input = try AVCaptureDeviceInput(device: captureDevice)
				
				// Initialize the captureSession object.
				captureSession = AVCaptureSession()
				
				// Set the input device on the capture session.
				captureSession?.addInput(input)
				
			} catch {
				// If any error occurs, simply print it out and don't continue any more.
				print(error)
				return
			}
			
			
			// Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
			let captureMetadataOutput = AVCaptureMetadataOutput()
			captureSession?.addOutput(captureMetadataOutput)
			
			// Set delegate and use the default dispatch queue to execute the call back
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
			
			// Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
			videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
			videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
			videoPreviewLayer?.frame = view.layer.bounds
			view.layer.addSublayer(videoPreviewLayer!)
			
			// Start video capture.
			captureSession?.startRunning()
			
			
			// Move the message label and top bar to the front
			view.bringSubview(toFront: messageLabel)
			view.bringSubview(toFront: titleLabel)
			view.bringSubview(toFront: gestureLabel)
			view.bringSubview(toFront: addButton)
			view.bringSubview(toFront: clearButton)
			view.bringSubview(toFront: gestureView)
			view.bringSubview(toFront: templateTextField)
			
			// Initialize QR Code Frame to highlight the QR code
			qrCodeFrameView = UIView()
			
			if let qrCodeFrameView = qrCodeFrameView {
				qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
				qrCodeFrameView.layer.borderWidth = 2
				view.addSubview(qrCodeFrameView)
				view.bringSubview(toFront: qrCodeFrameView)
			}
		}
		
		
		
        
	}


    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func didTapAddTemplate(_ sender: Any) {
        if
            let template = PennyPincher.createTemplate("pass", points: gestureView.points) {
            pennyPincherGestureRecognizer.templates.append(template)
        }
        gestureView.clear()
    }
    
    func didRecognize(_ pennyPincherGestureRecognizer: PennyPincherGestureRecognizer) {
        switch pennyPincherGestureRecognizer.state {
        case .ended, .cancelled, .failed:
            print("Riconosciuto")
            updateRecognizerResult()
        default: break
        }
    }
    
    private func updateRecognizerResult() {
        print("update recognizer")
        guard let (template, similarity) = pennyPincherGestureRecognizer.result else {
            gestureLabel.text = "Could not recognize."
            return
        }
        
        let similarityString = String(format: "%.2f", similarity)
        gestureLabel.text = "Template: \(template.id), Similarity: \(similarityString)"
        if(Double(similarityString)!>10.0){
            AuthenticateWithTouchID()
        }
    }
    

    
    @IBAction func didTapClear(_ sender: Any) {
        gestureLabel.text = ""
        gestureView.clear()
    }

    func AuthenticateWithTouchID() {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use TouchID
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        
                        if error != nil {
                            
                            switch error!._code {
                                
                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                                                err: error?.localizedDescription)
                                
                            case LAError.Code.userCancel.rawValue:
                                self.notifyUser("Please try again",
                                                err: error?.localizedDescription)
                                
                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                                                err: "Password option selected")
                                // Custom code to obtain password here
                                
                            default:
                                self.notifyUser("Authentication failed",
                                                err: error?.localizedDescription)
                            }
                            
                        } else {
                            self.performSegue(withIdentifier: "secretSegue", sender: nil)
                            self.notifyUser("Authentication Successful",err: "You now have full access")
                            
                            
                        }
                    }
            })
        } else {
            // Device cannot use TouchID
            switch error!.code{
                
            case LAError.Code.touchIDNotEnrolled.rawValue:
                notifyUser("TouchID is not enrolled",
                           err: error?.localizedDescription)
                
            case LAError.Code.passcodeNotSet.rawValue:
                notifyUser("A passcode has not been set",
                           err: error?.localizedDescription)
                
            default:
                notifyUser("TouchID not available",
                           err: error?.localizedDescription)
                
            }
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }


}

