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
    var i = 0
    @IBOutlet var gestureView: GestureView!
    
    @IBOutlet var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alert(message: "Now you should insert a gesture, we use it as password for your secret archive. You should insert a continuos gesture, try to not lift your finger", title: "BE ALERT!")
        pennyPincherGestureRecognizer.enableMultipleStrokes = true
        pennyPincherGestureRecognizer.allowedTimeBetweenMultipleStrokes = 0.2
        pennyPincherGestureRecognizer.cancelsTouchesInView = false
        pennyPincherGestureRecognizer.addTarget(self, action: #selector(didRecognize(_:)))
        
        gestureView.addGestureRecognizer(pennyPincherGestureRecognizer)
        navBar.topItem?.title = "Insert gesture "
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
            if(i != 0){
                updateRecognizerResult()
            }else{
                if(i==0){
                    if let template = PennyPincher.createTemplate("pass", points: gestureView.points) {
                        pennyPincherGestureRecognizer.templates.append(template)
                    }
                    for point in gestureView.points{
                        PersistenceManager.newItem(point)
                    }
                    self.alert(message: "Insert gesture again, for ensure that you draw it correct", title: "Good!")
                    navBar.topItem?.title = "Insert again"
                    i+=1;
                    print(gestureView.points.description.sha1())
                    gestureView.clear()
                }

            }
        default: break
        }
    }
    
    private func updateRecognizerResult() {
        guard let (_, similarity) = pennyPincherGestureRecognizer.result else {
            return
        }
        let similarityString = String(format: "%.2f", similarity)
        if(Double(similarityString)!>10.0){
             self.performSegue(withIdentifier: "okGesture", sender: nil)
            self.alert(message: "Gesture recorded", title: "Excellent!")
           
        }else{
             gestureView.clear()
            
            let alertController = UIAlertController(title: title, message: "Second gesture do not match, insert again or press cancel to redo you initial gesture", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler:{ (action: UIAlertAction!) in
                let gesture = PersistenceManager.fetchData()
                for point in gesture{
                    PersistenceManager.deleteItem(item: point)
                }
                PersistenceManager.saveContext()
                self.i = 0
                self.navBar.topItem?.title = "Please insert gesture"
                self.gestureView.clear()
            })
            
            alertController.addAction(OKAction)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
            //ErrorLabel.text = "Inserire dinuovo la gesture o premi cancel per reinserire la gesture iniziale"
        }
        
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
