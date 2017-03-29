//
//  ViewController.swift
//  Cykas
//
//  Created by Maurizio Casciano on 29/03/2017.
//  Copyright © 2017 Maurizio Casciano. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{
    //Declaring variables
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

