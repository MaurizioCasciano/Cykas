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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alert(message: "Now you must insert a gesture, we use it as password. If you lost it , you will lost all file", title: "BE ALERT!")
        pennyPincherGestureRecognizer.enableMultipleStrokes = true
        pennyPincherGestureRecognizer.allowedTimeBetweenMultipleStrokes = 0.2
        pennyPincherGestureRecognizer.cancelsTouchesInView = false
        pennyPincherGestureRecognizer.addTarget(self, action: #selector(didRecognize(_:)))
        
        gestureView.addGestureRecognizer(pennyPincherGestureRecognizer)
        ErrorLabel.text = "Inserisci la Gesture da utilizzare come protezione"
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
        }else{
             gestureView.clear()
            ErrorLabel.text = "Inserire dinuovo la gesture o premi cancel per reinserire la gesture iniziale"
        }
    }
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBAction func cancel(_ sender:UIButton)
    {
        let gesture = PersistenceManager.fetchData()
        for point in gesture{
            PersistenceManager.deleteItem(item: point)
        }
        PersistenceManager.saveContext()
        i = 0
        ErrorLabel.text = "Inserire dinuovo la gesture iniziale"
        gestureView.clear()
    }
    
    
    @IBAction func didTapAddTemplate(_ sender: UIButton) {
        if(i==0){
            if let template = PennyPincher.createTemplate("pass", points: gestureView.points) {
                pennyPincherGestureRecognizer.templates.append(template)
            }
            for point in gestureView.points{
                PersistenceManager.newItem(point)
            }
            ErrorLabel.text = "Inserire dinuovo la gesture"
            i+=1;
            print(gestureView.points.description.sha1())
            gestureView.clear()
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
