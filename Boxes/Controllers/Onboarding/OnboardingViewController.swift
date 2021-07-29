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
    
    var slides: [OnboardingSlide] = [
        OnboardingSlide(title: "Same But Different", description: "Experience what the other todo-list app couldn't give you. Be unique and motivated.", image: #imageLiteral(resourceName: "Image")),
        OnboardingSlide(title: "Each Box Is Special", description: "Modify each box to have it's own identity, making your tasks even more special.", image: #imageLiteral(resourceName: "Image-1")),
        OnboardingSlide(title: "Be Better Do More", description: "Create different tasks to different boxes, place deadlines, read motivational quotes. Do more tasks, be the better version of yourself", image: #imageLiteral(resourceName: "Image-2"))
    ]
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
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

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setUp(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}
