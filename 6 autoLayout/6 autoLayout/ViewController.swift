//
//  ViewController.swift
//  6 autoLayout
//
//  Created by Taha Saleh on 6/7/22.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstView = UIView()
        firstView.translatesAutoresizingMaskIntoConstraints = false
        firstView.backgroundColor = .red
       
        view.addSubview(firstView)
        
        let secondView = UIView()
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondView.backgroundColor = .cyan
        
        view.addSubview(secondView)
        
        let thirdView = UIView()
        thirdView.translatesAutoresizingMaskIntoConstraints = false
        thirdView.backgroundColor = .yellow
     
        view.addSubview(thirdView)
        
        let fourthView = UIView()
        fourthView.translatesAutoresizingMaskIntoConstraints = false
        fourthView.backgroundColor = .green
      
        view.addSubview(fourthView)
        
        let fifthView = UIView()
        fifthView.translatesAutoresizingMaskIntoConstraints = false
        fifthView.backgroundColor = .orange
       
        view.addSubview(fifthView)
        
        let firstHeight : NSLayoutConstraint = firstView.heightAnchor.constraint(equalToConstant: 88)
        firstHeight.priority = .defaultLow
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            firstView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            firstView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            firstHeight,
            
            
            secondView.topAnchor.constraint(equalTo: firstView.bottomAnchor),
            secondView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
            secondView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
            secondView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
            
            thirdView.topAnchor.constraint(equalTo: secondView.bottomAnchor),
            thirdView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
            thirdView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
            thirdView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
            
            fourthView.topAnchor.constraint(equalTo: thirdView.bottomAnchor),
            fourthView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
            fourthView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
            fourthView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
            
            fifthView.topAnchor.constraint(equalTo: fourthView.bottomAnchor),
            fifthView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
            fifthView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
            fifthView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
            fifthView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10)
        ])
        
    }
    
}

