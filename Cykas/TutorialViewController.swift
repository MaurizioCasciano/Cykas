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
    var nav:UINavigationController = UINavigationController()
    private let pennyPincherGestureRecognizer = PennyPincherGestureRecognizer()
    var i = 0
    @IBOutlet var gestureView: GestureView!
    var flag = false
    @IBOutlet var navBar: UINavigationBar!
    var temp:PennyPincherTemplate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var mssg = ""
        if(!flag){
             mssg = "Now you should insert a gesture, we use it as password for your secret archive. You should insert a continuos gesture, try to not lift your finger"
        }else{
            self.navigationController?.isNavigationBarHidden=true
            mssg = "Insert your new gesture"
        }
        self.alert(message: mssg, title: "BE ALERT!")
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
                if(flag)
                    {
                        updateGestureRecognizerResult()
                    }
                else
                    {
                        updateRecognizerResult()
                    }
            }else{
                if(i==0 && !flag){
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
                }else if(i==0 && flag){
                    temp = PennyPincher.createTemplate("pass", points: gestureView.points)
                    if(temp != nil) {
                        pennyPincherGestureRecognizer.templates.append(temp!)
                    }
                    self.alert(message: "Insert gesture again, for ensure that you draw it correct", title: "Good!")
                    navBar.topItem?.title = "Insert again"
                    i+=1;
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
        if(Double(similarityString)!>8.0){
            self.performSegue(withIdentifier: "okGesture", sender: nil)
            self.alert(message: "Gesture recorded", title: "Excellent!")
           
        }else{
             gestureView.clear()
            
            let alertController = UIAlertController(title: title, message: "Second gesture do not match, insert again or press cancel to redo you initial gesture", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
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

    private func updateGestureRecognizerResult() {
        guard let (_, similarity) = pennyPincherGestureRecognizer.result else {
            return
        }
        let similarityString = String(format: "%.2f", similarity)
        if(Double(similarityString)!>8.0){
            if(flag){
                var CS = CryptoString()
                class notaTemp{
                    public let nome:String?
                    public let data:String?
                    public let content:String?
                    init(n:String , d:String , c:String) {
                        nome=n
                        data=d
                        content=c
                    }
                }
                var notes = [notaTemp]()
                var images = [UIImage]()
                let arrayCripto1 = NotePersistenceManager.fetchData()
                var name = ""
                var datanota = ""
                var content = ""
                for note in arrayCripto1{
                    name = String(data:Encrypter.decrypt(data: note.name! as Data, password:CS.cryptoString!)  as Data, encoding: .utf8)!
                    datanota = String(data:Encrypter.decrypt(data: note.data! as Data, password: CS.cryptoString!)  as Data, encoding: .utf8)!
                    content = String(data:Encrypter.decrypt(data: note.content! as Data, password: CS.cryptoString!)  as Data, encoding: .utf8)!
                    let x = notaTemp(n:name , d:datanota , c:content)
                    notes.append(x)
                    NotePersistenceManager.deleteItem(item: note)
                    
                }
                NotePersistenceManager.saveContext()
                let arrayCripto = MediaPersistenceManager.fetchData()
                for img in arrayCripto{
                    let dataimg = Encrypter.decrypt(data: img.binaryDate! as Data, password: CS.cryptoString!)
                    images.append(UIImage(data: dataimg)!)
                    MediaPersistenceManager.deleteItem(item: img)
                }
                MediaPersistenceManager.saveContext()
                
                for p in PersistenceManager.fetchData(){
                    PersistenceManager.deleteItem(item: p)
                }
                PersistenceManager.saveContext()
                for point in gestureView.points
                {
                PersistenceManager.newItem(point)
                }
                CS = CryptoString()
                for not in notes{
                    let namedata = not.nome?.data(using: .utf8) as NSData?
                    let contentdata = not.content?.data(using: .utf8) as NSData?
                    let datadata = not.data?.data(using: .utf8) as NSData?
                    let name = Encrypter.encrypt(data: namedata! as Data, password: CS.cryptoString!) as NSData
                    let content = Encrypter.encrypt(data: contentdata! as Data, password: CS.cryptoString!) as NSData
                    let data = Encrypter.encrypt(data: datadata! as Data, password: CS.cryptoString!) as NSData
                    NotePersistenceManager.newItem(nome:name ,dat:data, cont:content)
                }
                NotePersistenceManager.saveContext()
                for item in images{
                    MediaPersistenceManager.newItem(item)
                }
                MediaPersistenceManager.saveContext()
                
            }
        }else{
            gestureView.clear()
            let alertController = UIAlertController(title: title, message: "Second gesture do not match, insert again or press cancel to redo you initial gesture", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler:{ (action: UIAlertAction!) in
                self.pennyPincherGestureRecognizer.templates.removeAll()
                self.i=0
                self.navBar.topItem?.title = "Please insert gesture"
                self.gestureView.clear()
            })
            alertController.addAction(OKAction)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
            //ErrorLabel.text = "Inserire dinuovo la gesture o premi cancel per reinserire la gesture iniziale"
        }
        let alertController = UIAlertController(title: "Gesture Change", message: "Restart the App for make persistent the changement", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) in exit(0)})
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
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
