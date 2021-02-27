//
//  CustomAlertViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 25/02/21.
//

import UIKit
import ISEmojiView

class CustomAlertViewController: UIViewController, EmojiViewDelegate {
    
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        textView.insertText(emoji)
    }

    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        textView.inputView = nil
        textView.keyboardType = .default
        textView.reloadInputViews()
    }
        
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        textView.deleteBackward()
    }

    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        textView.resignFirstResponder()
    }

    @IBOutlet weak var boxView: UIView?
    
    @IBOutlet weak var iconLabel: UILabel!
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var cancelButtonView: UIButton!
    @IBOutlet weak var addboxButtonView: UIButton!
    @IBOutlet weak var rectangleView: UIView!
    
    var color = C()
    var boxColor = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
        boxColor = color.randomColor()
        boxView?.layer.borderColor = UIColor(named: boxColor)?.cgColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
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
        
        if nameTextView.text == nil || nameTextView.text == "" {
            Alert.alertNoTitle(on: self, with: "What? No Title?", message: "How would you put something on nothing?... Serious man, get help... ;)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if nameTextView.text == nil || nameTextView.text == "" {
        } else {
            let destVC = segue.destination as! BoxesViewController
            destVC.createBox(name: nameTextView.text!, icon: textView.text ?? "", color: boxColor)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {}
    
}

extension CustomAlertViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        iconLabel.text = textField.text
    }
}
