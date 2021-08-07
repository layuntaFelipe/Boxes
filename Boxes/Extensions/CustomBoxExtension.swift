//
//  CustomBoxExtension.swift
//  Boxes
//
//  Created by Felipe Lobo on 07/08/21.
//

import Foundation
import UIKit
import ISEmojiView

extension CustomBoxViewController: EmojiViewDelegate {
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
}

extension CustomBoxViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        iconLabel.text = textField.text
    }
}

extension EmojiView{
    func setupView() {
        if #available(iOS 13, *) {
            backgroundColor = UIColor.secondarySystemBackground
        }
        else {
            backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        }
    }
}
