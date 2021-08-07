//
//  OnboardingViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 28/07/21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let userDefaultStorage = UserDefaults()
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
                nextButton.backgroundColor = UIColor.orange
            } else {
                nextButton.setTitle("Next", for: .normal)
                nextButton.backgroundColor = UIColor.darkGray
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if currentPage == slides.count - 1 {
            userDefaultStorage.setOnboardingSeen()
            let controller = storyboard?.instantiateViewController(identifier: "HomeVC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}
