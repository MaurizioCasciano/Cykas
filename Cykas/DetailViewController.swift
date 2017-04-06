//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var contentField: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    var item: Notes!
    let CS = CryptoString()
    
    @IBAction func Clear(_ sender: UIBarButtonItem) {
        nameField.text = ""
        contentField.text = ""
        dateLabel.text = dateFormatter.string(from: Date() as Date)

    }
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = String(data:Encrypter.decrypt(data: item.name! as Data, password: CS.cryptoString!)  as Data, encoding: .utf8)
        contentField.text = String(data:Encrypter.decrypt(data: item.content! as Data, password: CS.cryptoString!)  as Data, encoding: .utf8)
        dateLabel.text = String(data:Encrypter.decrypt(data: item.data! as Data, password: CS.cryptoString!)  as Data, encoding: .utf8)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let name=nameField.text
        let content=contentField.text
        let datadat = Date()
        let date = dateFormatter.string(from: datadat)
        let namedata = name?.data(using: .utf8) as NSData?
        let contentdata = content?.data(using: .utf8) as NSData?
        let datadata = date.data(using: .utf8) as NSData?
        item.name = Encrypter.encrypt(data: namedata! as Data, password: CS.cryptoString!) as NSData
        item.content = Encrypter.encrypt(data: contentdata! as Data, password: CS.cryptoString!) as NSData
        item.data = Encrypter.encrypt(data: datadata! as Data, password: CS.cryptoString!) as NSData
        NotePersistenceManager.saveContext()
        // Clear first responder
        view.endEditing(true)
        // "Save" changes to item
        
        
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
