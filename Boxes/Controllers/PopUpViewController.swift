//
//  PopUpViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 14/03/21.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var popUpView: UIView!
    
    var popUpTitle = String()
    var popUpDescription = String()
    var popUpDate : String?
    var color = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.borderWidth = 3
        popUpView.layer.borderColor = UIColor.lightGray.cgColor
        
        setupView()
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    func setupView() {
        titleView.text = popUpTitle
        descriptionView.text = popUpDescription
        dateView.text = popUpDate ?? ""
        popUpView.backgroundColor = color
    }
    
}
