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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.gray.cgColor
        
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        
        datePickerView.isHidden = true
        
    }
    
    func localCreateItem(title: String, text: String) -> [String] {
        
        return [title, text]

    }
    
    @IBAction func switchButtonPressed(_ sender: UISwitch) {
        
        if sender.isOn {
            datePickerView.isHidden = false
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
        let destVC = segue.destination as! ItemsTableViewController
        destVC.namesArray = localArray
        destVC.createItem(title: localArray[0], text: localArray[1])
    }
    
}
