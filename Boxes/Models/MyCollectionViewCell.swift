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
    @IBOutlet weak var deleteButtonView: UIButton!
    
    var deleteHidden: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteButtonView.isHidden = true
        deleteButtonView.layer.cornerRadius = deleteButtonView.bounds.size.height/2
        
        backgroundCellView.layer.cornerRadius = 10
        backgroundCellView.layer.borderWidth = 1
        backgroundCellView.layer.borderColor = UIColor.gray.cgColor
        
        circleView.layer.cornerRadius = circleView.bounds.size.height/2
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        print("delete box!")
    }

}
