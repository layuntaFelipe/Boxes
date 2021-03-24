//
//  AlertModels.swift
//  Boxes
//
//  Created by Felipe Lobo on 04/02/21.
//

import Foundation
import UIKit

struct Alert {
    
    func alert(vc: UIViewController,title: String, message: String, style: UIAlertController.Style) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        vc.present(alert, animated: true, completion: nil)
        return alert
    }
    
}

struct CustomBox {
    func box() -> CustomBoxViewController {
        let storyboard = UIStoryboard(name: "CustomBoxView", bundle: .main)
        let boxVC = storyboard.instantiateViewController(withIdentifier: "BoxVC") as! CustomBoxViewController
        return boxVC
    }
}

struct PopUpService {
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
