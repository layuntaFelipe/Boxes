//
//  MyCollectionViewCell.swift
//  Boxes
//
//  Created by Felipe Lobo on 01/02/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backgroundCellView: UIView!
    @IBOutlet var circleView: UIView!
    @IBOutlet var iconView: UILabel!
    @IBOutlet var titleView: UILabel!
    @IBOutlet var numberView: UILabel!
    
    var numberTitle = "12"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = CAGradientLayer()
        layer.frame = backgroundCellView.bounds
        layer.colors = [UIColor(named: "gradientColor1")!, UIColor(named: "gradientColor2")!]
        
        numberView.text = numberTitle
        
        backgroundCellView.setGradient(topColor: Colors.topColor!, buttomColor: Colors.buttomColor!)
        backgroundCellView.layer.cornerRadius = 10
        backgroundCellView.layer.borderWidth = 1
        backgroundCellView.layer.borderColor = UIColor.gray.cgColor
        
        circleView.layer.cornerRadius = circleView.bounds.size.height/2
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }

}
