//
//  CustomAlertViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 25/02/21.
//

import UIKit
import ISEmojiView
import ChameleonFramework

class CustomBoxViewController: UIViewController{

    @IBOutlet weak var boxView: UIView?
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var cancelButtonView: UIButton!
    @IBOutlet weak var addboxButtonView: UIButton!
    @IBOutlet weak var rectangleView: UIView!
    
    private var boxColor = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
        boxColor = UIColor.randomFlat().hexValue()
        boxView?.layer.borderColor = UIColor(hexString: boxColor)?.cgColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.setupView()
        emojiView.delegate = self
        textView.inputView = emojiView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        boxView?.layer.cornerRadius = 10
        boxView?.layer.borderWidth = 3
        boxView?.layer.borderColor = UIColor.gray.cgColor
        
        rectangleView.layer.cornerRadius = 10
        
        cancelButtonView.layer.borderWidth = 0.5
        cancelButtonView.layer.borderColor = UIColor.gray.cgColor
        
        addboxButtonView.layer.borderWidth = 0.5
        addboxButtonView.layer.borderColor = UIColor.gray.cgColor
        
        textView.delegate = self
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let alert = Alert()
        
        if nameTextView.text == nil || nameTextView.text == "" {
            alert.alert(vc: self, title: "What? No Title?", message: "How would you put something on nothing?... Serious man, get help... ;)", style: .alert)
        } else if textView.text == nil || textView.text == "" {
            alert.alert(vc: self, title: "What? No Icon?", message: "How would you place something whithout a icon?", style: .alert)
        } else {
            performSegue(withIdentifier: "ExitBox", sender: self)
            print("Doing the perform")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! BoxesViewController
        destVC.createBox(name: nameTextView.text!, icon: textView.text!, color: boxColor)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
