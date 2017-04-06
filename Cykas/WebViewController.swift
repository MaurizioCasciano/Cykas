//
//  WebViewController.swift
//  Cykas
//
//  Created by Marco Feoli on 06/04/17.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var web: UIWebView!

    var QRLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: QRLink)
        let request = NSURLRequest(url: url! as URL)
        
        web.loadRequest(request as URLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }        
}
