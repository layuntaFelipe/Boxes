//
//  AnimationViewController.swift
//  Boxes
//
//  Created by Felipe Lobo on 09/02/21.
//

import UIKit

class AnimationViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var redball: UIImageView!
    @IBOutlet weak var skyBall: UIImageView!
    @IBOutlet weak var purpleBall: UIImageView!
    @IBOutlet weak var darkgreenBall: UIImageView!
    @IBOutlet weak var blueBall: UIImageView!
    @IBOutlet weak var yellowBall: UIImageView!
    @IBOutlet weak var orangeBall: UIImageView!
    @IBOutlet weak var greenBall: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3.3
            let diffx = size - self.view.frame.size.width
            let diffy = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffx/2),
                                          y: diffy/2,
                                          width: size,
                                          height: size)
        })
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        }) { (done) in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.performSegue(withIdentifier: "animationToBoxes", sender: self)
                }
            }
        }
    }
}
