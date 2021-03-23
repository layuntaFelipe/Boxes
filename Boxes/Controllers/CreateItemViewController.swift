//
//  CreateItemViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 02/02/21.
//

import UIKit
import CoreData
import ChameleonFramework

class CreateItemViewController: UIViewController {
    
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var newItemView: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var switchButtonView: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonView: UIButton!
    
    private var localArray = [String]()
    
    private var itemSelected : ToDoItems? {
        didSet {
            print("Item Setterd")
            print(itemSelected!)
        }
    }
    
    private var endDate : Date?
    
    private var deadLine = false
    
    private var isToCreate = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titleColor = ContrastColorOf(view.backgroundColor!, returnFlat: true)
        newItemView.textColor = titleColor
        titleLabel.textColor = titleColor
        descriptionLabel.textColor = titleColor
        deadLineLabel.textColor = titleColor
        buttonView.tintColor = titleColor
        datePickerView.tintColor = titleColor
    }
    
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
            sender.isOn = false
            sender.isOn = true
            deadLine = true
            datePickerView.isHidden = false
        } else {
            sender.isOn = true
            sender.isOn = false
            deadLine = false
            datePickerView.isHidden = true
        }
        
    }
    @IBAction func datePickerOpened(_ sender: UIDatePicker) {
        if deadLine {
            endDate = sender.date
        }
        print(endDate ?? "O DATE PICKE NAO ABRIU PROCURE SABER")
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        
        localArray = localCreateItem(title: titleTextField.text!, text: textView.text ?? "")
        //Solve the problem in case of not having a endDate
        print("The endDate is equal to: \(String(describing: endDate))")
        print("local array: \(localArray)")
        print("dismissing newView")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if titleTextField.text == nil || titleTextField.text == "" {
            Alert.alertNoTitle(on: self, with: "What? No Title?", message: "How would you do nothing?... Serious man, get help... ;)")
        } else {
            let destVC = segue.destination as! ItemsTableViewController
            destVC.namesArray = localArray
            if deadLine {
                endDate = datePickerView.date
            }
            destVC.createItem(title: localArray[0], text: localArray[1], deadLine: deadLine, endDate: endDate)
            print("The end date created is: \(String(describing: endDate))")
        }
        
    }
}
