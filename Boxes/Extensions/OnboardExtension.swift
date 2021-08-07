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

extension OnboardingViewController: DefaultCollectionMethods, UICollectionViewDelegateFlowLayout {
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
