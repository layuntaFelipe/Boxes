//
//  UserDefaultExtention.swift
//  Boxes
//
//  Created by Felipe Lobo on 29/07/21.
//

import UIKit

extension UserDefaults {
    func isOnboardingSeen() -> Bool {
        UserDefaults.standard.bool(forKey: "onboardingSeen")
    }
    
    func setOnboardingSeen() {
        UserDefaults.standard.set(true, forKey: "onboardingSeen")
    }
    
    func resetOnboardingSeen() {
        UserDefaults.standard.set(false, forKey: "onboardingSeen")
    }
}
