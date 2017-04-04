//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var contentField: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    var item: Notes!
    
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
        nameField.text = item.name
        contentField.text = item.content
        dateLabel.text = dateFormatter.string(from: item.data! as Date)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        item.name=nameField.text
        item.content=contentField.text
        item.data = dateFormatter.date(from: dateLabel.text!)! as NSDate
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
