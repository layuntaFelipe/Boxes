//
//  AnimationViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 09/02/21.
//

import UIKit

class AnimationViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var xView: UIView!
    @IBOutlet weak var plusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(xView)
        view.addSubview(plusView)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateRotation()
    }
    
    private func animateRotation() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = 0
        animation.toValue = CGFloat.pi
        animation.duration = 1

        xView.layer.add(animation, forKey: "basic")
        xView.layer.transform = CATransform3DMakeRotation(CGFloat.pi , 0, 0, 1)
        plusView.layer.add(animation, forKey: "basic")
        plusView.layer.transform = CATransform3DMakeRotation(CGFloat.pi , 0, 0, 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.performSegue(withIdentifier: "animationToBoxes", sender: self)
        }

    }
    
}
