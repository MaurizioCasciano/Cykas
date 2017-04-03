//
//  TutorialViewController.swift
//  Cykas
//
//  Created by ANTONIO ALBERINI on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit
import PennyPincher

class TutorialViewController: UIViewController {

    private let pennyPincherGestureRecognizer = PennyPincherGestureRecognizer()
    
    @IBOutlet var gestureView: GestureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pennyPincherGestureRecognizer.enableMultipleStrokes = true
        pennyPincherGestureRecognizer.allowedTimeBetweenMultipleStrokes = 0.2
        pennyPincherGestureRecognizer.cancelsTouchesInView = false
        pennyPincherGestureRecognizer.addTarget(self, action: #selector(didRecognize(_:)))
        
        gestureView.addGestureRecognizer(pennyPincherGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didRecognize(_ pennyPincherGestureRecognizer: PennyPincherGestureRecognizer) {
        switch pennyPincherGestureRecognizer.state {
        case .ended, .cancelled, .failed:
            print("Riconosciuto")
        default: break
        }
    }
    
    @IBAction func didTapAddTemplate(_ sender: UIButton) {
        
            if let template = PennyPincher.createTemplate("pass", points: gestureView.points) {
                pennyPincherGestureRecognizer.templates.append(template)
            }
            for point in gestureView.points{
                PersistenceManager.newItem(point)
            }
            print(gestureView.points.description.sha1())
            gestureView.clear()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
