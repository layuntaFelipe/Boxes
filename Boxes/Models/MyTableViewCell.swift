//
//  MyTableViewCell.swift
//  Boxes
//
//  Created by Felipe Lobo on 05/02/21.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var endDateLabel: UILabel!
    
    var didSelectEndDate: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundViewCell.layer.cornerRadius = 10
        backgroundViewCell.layer.borderWidth = 1
        backgroundViewCell.layer.borderColor = UIColor.gray.cgColor
        
        if didSelectEndDate {
            redView.isHidden = false
        } else {
            redView.isHidden = true
        }
        redView.layer.cornerRadius = 10
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
//    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
