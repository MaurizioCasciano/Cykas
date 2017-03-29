//
//  ViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 29/03/2017.
//  Copyright © 2017 Maurizio Casciano. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var gestureLabel: UILabel!
    @IBOutlet var renderView: RenderView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var rawPoints:[Int] = []
    var recognizer:DBPathRecognizer?
	override func viewDidLoad() {
		super.viewDidLoad()
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
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
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
        //Now start code for secrets
        //********************************************************************************************
        //********************************************************************************************
        //********************************************************************************************
        //********************************************************************************************
        //********************************************************************************************
        //********************************************************************************************
        //********************************************************************************************
        
        //define the number of direction of PathModel
        let recognizer = DBPathRecognizer(sliceCount: 7, deltaMove: 16.0)
        
        //define specific formes to draw on PathModel
        recognizer.addModel(PathModel(directions: [7,1,4,1,7,5,3], datas:"Bravoh" as AnyObject))
        recognizer.addModel(PathModel(directions: [7, 1], datas:"A" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,6,0,1,2,3,4,0,1,2,3,4], datas:"B" as AnyObject))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0], datas:"C" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,6,7,0,1,2,3,4], datas:"D" as AnyObject))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,4,3,2,1,0], datas:"E" as AnyObject))
        recognizer.addModel(PathModel(directions: [4,2], datas:"F" as AnyObject))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5,0], datas:"G" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,6,7,0,1,2], datas:"H" as AnyObject))
        recognizer.addModel(PathModel(directions: [2], datas:"I" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,3,4], datas:"J" as AnyObject))
        recognizer.addModel(PathModel(directions: [3,4,5,6,7,0,1], datas:"K" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,0], datas:"L" as AnyObject))
        recognizer.addModel(PathModel(directions: [6,1,7,2], datas:"M" as AnyObject))
        recognizer.addModel(PathModel(directions: [6,1,6], datas:"N" as AnyObject))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5,4], datas:"O" as AnyObject))
        recognizer.addModel(PathModel(directions: [6,7,0,1,2,3,4], datas:"P" as AnyObject))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5,4,0], datas:"Q" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,6,7,0,1,2,3,4,1], datas:"R" as AnyObject))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,1,2,3,4], datas:"S" as AnyObject))
        recognizer.addModel(PathModel(directions: [0,2], datas:"T" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,1,0,7,6], datas:"U" as AnyObject))
        recognizer.addModel(PathModel(directions: [1,7,0], datas:"V" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,7,1,6], datas:"W" as AnyObject))
        recognizer.addModel(PathModel(directions: [1,0,7,6,5,4,3], datas:"X" as AnyObject))
        recognizer.addModel(PathModel(directions: [2,1,0,7,6,2,3,4,5,6,7], datas:"Y" as AnyObject))
        recognizer.addModel(PathModel(directions: [0,3,0], datas:"Z" as AnyObject))

        
        self.recognizer = recognizer
        
        
	}

    //takes the coordinates of the first touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rawPoints = []
        let touch = touches.first
        let location = touch!.location(in: view)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))
    }
    
    //takes all coordinates if touch moves and
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch!.location(in: view)
        if(rawPoints[rawPoints.count-2] != Int(location.x) && rawPoints[rawPoints.count-1] != Int(location.y)) {
            rawPoints.append(Int(location.x))
            rawPoints.append(Int(location.y))
        }

    }
    
    //create the final path and makes action is letter is S
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var path:Path = Path()
        path.addPointFromRaw(rawPoints)
        
        let gesture:PathModel? = self.recognizer!.recognizePath(path)
        
        if gesture != nil {
            let letters = gesture!.datas as? String
            gestureLabel.text = letters
        }
        else
        {
            gestureLabel.text = ""
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


}

