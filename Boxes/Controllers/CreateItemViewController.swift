//
//  CreateItemViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 02/02/21.
//

import UIKit
import CoreData

class CreateItemViewController: UIViewController {

    @IBOutlet weak var newItemView: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var localArray = [String]()
    
    var endDate = Date()
    
    var isToCreate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.gray.cgColor
        
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        
        datePickerView.isHidden = true
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func localCreateItem(title: String, text: String) -> [String] {
        
        return [title, text]

    }
    
    @IBAction func switchButtonPressed(_ sender: UISwitch) {
        
        if sender.isOn {
            datePickerView.isHidden = false
            endDate = datePickerView.date
        } else {
            datePickerView.isHidden = true
        }
        
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        
        localArray = localCreateItem(title: titleTextField.text!, text: textView.text ?? "")
        print("local array: \(localArray)")
        print("dismissing newView")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if titleTextField.text == nil || titleTextField.text == "" {
            Alert.alertNoTitle(on: self, with: "What? No Title?", message: "How would you do nothing?... Serious man, get help... ;)")
        } else {
            if isToCreate {
                let destVC = segue.destination as! ItemsTableViewController
                destVC.namesArray = localArray
                destVC.createItem(title: localArray[0], text: localArray[1])
            } else {
                let destVC = segue.destination as! ItemsTableViewController
//                destVC.update
            }
        }
    }
    
}
