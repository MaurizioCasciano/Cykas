//
//  InitViewController.swift
//  Cykas
//
//  Created by ANTONIO ALBERINI on 03/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {
var gesture = [TemplateGesture]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gesture = PersistenceManager.fetchData()
        if (gesture.isEmpty){
            self.performSegue(withIdentifier: "TutorialView", sender: nil)
            //gestureLabel.text = "Inserisci la nuova gesture e premere add"
        }else{
            /*gestureLabel.text = "Inserisci la gesture inserita in precedenza"
             var y = [CGPoint]()
             for pointgesture in gesture{
             y.append(CGPointFromString(pointgesture.point!))
             }
             template = PennyPincher.createTemplate("pass", points: y)!
             pennyPincherGestureRecognizer.templates.append(template)*/
            self.performSegue(withIdentifier: "QRView", sender: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
