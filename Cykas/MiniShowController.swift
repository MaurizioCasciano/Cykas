//
//  MiniShowController.swift
//  Cykas
//
//  Created by Domenico Antonio Tropeano on 05/04/2017.
//  Copyright © 2017 ALBA. All rights reserved.
//

import UIKit

class MiniShowController: UIViewController {
    var current:Int=1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imgViewShowTut.image=UIImage(named:"tut1.png")
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(MiniShowController.respondToSwipeGesture(gesture:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:  #selector(MiniShowController.respondToSwipeGesture(gesture:)))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    @IBOutlet var imgViewShowTut: UIImageView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.left:
                current=current+1
                print("Now current is:\(current) ")
                if(current>5){
                    current=5
                    self.performSegue(withIdentifier: "finishTut", sender: nil)
                    
                }else{
                    UIView.transition(with: self.imgViewShowTut,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.imgViewShowTut.image = UIImage(named:"tut"+String(self.current)+".png")
                                        
                    },
                                      completion: nil)
                }
                break
                
                
            case UISwipeGestureRecognizerDirection.right:
                print("Now current is:\(current) ")
                current=current-1
                if(current<1){
                    current=1
                }else{
                    UIView.transition(with: self.imgViewShowTut,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.imgViewShowTut.image=UIImage(named:"tut"+String(self.current)+".png")
                                        
                    },
                                      completion: nil)
                    
                }
                break
                
            default:
                break
            }
        }
    }
    
}
