//
//  CustomAlertViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 25/02/21.
//

import UIKit

class CustomAlertViewController: UIViewController {

    @IBOutlet weak var boxView: UIView?
    
    @IBOutlet weak var iconLabel: UILabel!
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var cancelButtonView: UIButton!
    @IBOutlet weak var addboxButtonView: UIButton!
    @IBOutlet weak var rectangleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        boxView?.layer.cornerRadius = 10
        boxView?.layer.borderWidth = 1
        boxView?.layer.borderColor = UIColor.gray.cgColor
        
        rectangleView.layer.cornerRadius = 10
        
        cancelButtonView.layer.borderWidth = 1
        cancelButtonView.layer.borderColor = UIColor.gray.cgColor
        
        addboxButtonView.layer.borderWidth = 1
        addboxButtonView.layer.borderColor = UIColor.gray.cgColor
        
        textView.delegate = self
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if nameTextView.text == nil || nameTextView.text == "" {
            Alert.alertNoTitle(on: self, with: "What? No Title?", message: "How would you put something on nothing?... Serious man, get help... ;)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if nameTextView.text == nil || nameTextView.text == "" {
        } else {
            let destVC = segue.destination as! BoxesViewController
            destVC.createBox(name: nameTextView.text!, icon: textView.text ?? "")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {}
    
}

extension CustomAlertViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        iconLabel.text = textField.text
    }
}
