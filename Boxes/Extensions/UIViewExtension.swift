//
//  UIViewExtension.swift
//  Boxes
//
//  Created by Felipe Lobo on 28/07/21.
//

import UIKit

extension UIView {
   @IBInspectable var cornerRadius: CGFloat {
        get {
            return cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
