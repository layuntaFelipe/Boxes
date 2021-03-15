//
//  AlertModels.swift
//  Boxes
//
//  Created by Felipe Lobo on 04/02/21.
//

import Foundation
import UIKit

class Alert {
    
    static func alertNoTitle(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}

class AlertService {
    
    func alert() -> CustomAlertViewController {
        
        let storyboard = UIStoryboard(name: "CustomAlertView", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! CustomAlertViewController
        
        return alertVC
    }
    
}

class PopUpService {
    func popUp(title: String, description: String, dateString: String?, color: UIColor) -> UIViewController {
        let storyboard = UIStoryboard(name: "PopUpView", bundle: .main)
        let popUp = storyboard.instantiateViewController(identifier: "PopUpVC") as! PopUpViewController
        popUp.popUpTitle = title
        popUp.popUpDescription = description
        popUp.popUpDate = dateString
        popUp.color = color
        
        return popUp
    }
}
