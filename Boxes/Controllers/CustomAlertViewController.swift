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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxView?.layer.cornerRadius = 10
        boxView?.layer.borderWidth = 1
        boxView?.layer.borderColor = UIColor.gray.cgColor
        
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    
}
