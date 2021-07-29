//
//  ShowOnboardingViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 29/07/21.
//

import UIKit

class ShowOnboardingViewController: UIViewController {
    
    private var isOnboardingSeen: Bool!
    private let userDefaultStorage = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        isOnboardingSeen = userDefaultStorage.isOnboardingSeen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialScreen()
    }
    
    private func showInitialScreen() {
        var controller = UIViewController()
        if isOnboardingSeen {
            controller = storyboard?.instantiateViewController(identifier: "HomeVC") as! UINavigationController
        } else {
            controller = storyboard?.instantiateViewController(identifier: "OnboardingViewController") as! OnboardingViewController
        }
        controllerSetUp(controller)
    }
    
    private func controllerSetUp(_ controller: UIViewController) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }

}
