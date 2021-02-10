//
//  GradientAndColors.swift
//  Boxes
//
//  Created by Felipe Lobo on 09/02/21.
//

import Foundation
import UIKit

extension UIView {
    
    public func setGradient(topColor: UIColor, buttomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 10
        gradientLayer.colors = [topColor.cgColor, buttomColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

struct Colors {
    static let topColor = UIColor(named: "gradientColor1")
    
    static let buttomColor = UIColor(named: "gradientColor2")
}
