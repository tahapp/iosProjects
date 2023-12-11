//
//  ViewController.swift
//  15 Animatio
//
//  Created by Taha Saleh on 10/15/22.
//

import UIKit

class ViewController: UIViewController {

    let imageView = UIImageView(image: UIImage(named: "penguin"))
    let animateButton = UIButton()
    var currentAnimation = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size = CGSize(width: 400, height: 300)
        
        animateButton.translatesAutoresizingMaskIntoConstraints = false
        animateButton.setTitle("animate", for: .normal)
        animateButton.titleLabel?.font = .systemFont(ofSize: 20)
        animateButton.setTitleColor(.black, for: .normal)
        animateButton.addTarget(self, action: #selector(animate), for: .touchUpInside)
        
        
        view.addSubview(animateButton)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            animateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animateButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }

    @objc func animate(_ sender: UIButton)
    {
        
        animateButton.isHidden = true
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: [.calculationModeCubicPaced], animations: runAnimation, completion: {
            [weak self] _ in
            self?.animateButton.isHidden = false
        })
        
    }
    
    func runAnimation()
    {
        let start = self.imageView.center
        UIView.addKeyframe(withRelativeStartTime: 0.10, relativeDuration: 0.25)
        {
            self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }

        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25)
        {
            self.imageView.transform = CGAffineTransform(translationX: -100, y: -100)
        }

        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25)
        {
            self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
        }

        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25)
        {
            self.imageView.center = start
        }
        
        UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.25)
        {
            self.imageView.transform = .identity
        }
        
    }
}

