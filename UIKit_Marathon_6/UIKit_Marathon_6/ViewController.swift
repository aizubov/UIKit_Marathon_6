//
//  ViewController.swift
//  UIKit_Marathon_6
//
//  Created by user228564 on 3/17/23.
//

import UIKit

class ViewController: UIViewController {
    var initialPosition: Bool = true
    
    let myView = UIView(frame: CGRect(x: 50, y: 100, width: 80, height: 80))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myView.layer.cornerRadius = 10
        myView.clipsToBounds = true
        myView.layer.masksToBounds = true
        myView.backgroundColor = .systemBlue
        
        view.addSubview(myView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tapCoordinates = sender.location(in: view)
            
        let dx = tapCoordinates.x - myView.center.x
        let dy = tapCoordinates.y - myView.center.y
        let distance = abs(dx + dy)
        let angleCoefficient = min(abs(dx + dy)/3000, 0.05)
        
        let rotatingTime = min(distance/8000, 0.6)
        let transitionTime = CFTimeInterval(3)
    
        let springAnimation = CASpringAnimation(keyPath: "position")
        springAnimation.initialVelocity = 0
        springAnimation.stiffness = 100.0
        springAnimation.fromValue = myView.layer.position
        springAnimation.damping = 10
        springAnimation.mass = min(distance/200, 0.7)
        springAnimation.toValue = tapCoordinates
        springAnimation.duration = transitionTime
        
        let rotationTransformRight = CGAffineTransform(rotationAngle: CGFloat.pi * angleCoefficient)
        let rotationTransformLeft = CGAffineTransform(rotationAngle: -CGFloat.pi * angleCoefficient)
        
        let movementAnimation: Void = UIView.animateKeyframes(withDuration: transitionTime, delay: 0.0,
            animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: transitionTime,
              animations: {
                self.myView.center = tapCoordinates
              })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: rotatingTime,
              animations: {
                if (dx > 0 && dy > 0) || (dx > 0 && dy < 0) {            self.myView.transform = rotationTransformRight
                } else {
                    self.myView.transform = rotationTransformLeft
                }
              })
            UIView.addKeyframe(withRelativeStartTime: rotatingTime, relativeDuration: rotatingTime,
              animations: {
                self.myView.transform = .identity
              })
            },
            completion: nil
          )
        
        let animator = UIViewPropertyAnimator(duration: transitionTime, curve: .easeInOut)
                animator.addAnimations {
                    movementAnimation
                    self.myView.layer.add(springAnimation, forKey: nil)
                }
        animator.startAnimation()
    }
}
