//
//  ViewController.swift
//  2 Guess the flag
//
//  Created by Taha Saleh on 5/5/22.
//

import UIKit


final class ViewController: UIViewController
{
   private let button1 = UIButton()
   private let button2 = UIButton()
   private let button3 = UIButton()
    
   private var countries = ["estonia","france","germany",
                            "ireland","monaco","nigeria",
   "poland","russia","spain","uk","us"]
    
    private var score : Int = 0
    private var currentAnswer = 0
   
    private var portraitHeightConstrint : NSLayoutConstraint!
    private var landscapeHeightConstrint : NSLayoutConstraint!
    
    
    override  func loadView()
    {
        let v = UIView()
        v.backgroundColor = .systemBackground
        self.view = v
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        
        portraitHeightConstrint = button1.heightAnchor.constraint(equalToConstant: 100)
        landscapeHeightConstrint = button1.heightAnchor.constraint(equalToConstant: 85)

        
        button2.tag = 1
        button3.tag = 2
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.addTarget(self, action: #selector(tapFlag(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(tapFlag(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(tapFlag(_:)), for: .touchUpInside)
        
        
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        askQuestion(nil)
        layoutConstraints()
    }
 
   
    override func viewWillLayoutSubviews()
    {

        if UIDevice.current.orientation == .landscapeRight ||
            UIDevice.current.orientation == .landscapeLeft
        {
            portraitHeightConstrint.isActive = false
            landscapeHeightConstrint.isActive = true


        }else if UIDevice.current.orientation == .portrait
        {
            landscapeHeightConstrint.isActive = false
            portraitHeightConstrint.isActive = true

        }

    }
   private func layoutConstraints()
    {
    
        NSLayoutConstraint.activate([
            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            button1.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button1.widthAnchor.constraint(equalTo: button1.heightAnchor,multiplier: 2.0),
            
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor,constant: 20),
            button2.centerXAnchor.constraint(equalTo: button1.centerXAnchor),
            button2.widthAnchor.constraint(equalTo: button1.widthAnchor),
            button2.heightAnchor.constraint(equalTo: button1.heightAnchor),
            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor,constant: 20),
            button3.centerXAnchor.constraint(equalTo: button2.centerXAnchor),
            button3.widthAnchor.constraint(equalTo: button1.widthAnchor),
            button3.heightAnchor.constraint(equalTo: button1.heightAnchor),
        ])
    
    }
    private func askQuestion(_ :UIAlertAction?)
   {
    countries.shuffle()
    
    currentAnswer = Int.random(in: 0...2)
    
    self.title = countries[currentAnswer].uppercased()
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)
    
    
   }
    
    @objc func tapFlag(_ sender:UIButton)
    {
        let title:String
        if sender.tag == currentAnswer
        {
            title = "correct"
            score += 1
            let action = UIAlertAction(title: "continue", style: .default, handler:askQuestion(_:))
            showAlertController(title,action: action)
        }else{
            title = "incorrect"
            score -= 1
             let action = UIAlertAction(title: "continue", style: .default, handler:nil)
            showAlertController(title,action: action)
        }
        
    }
    
    func showAlertController(_ message:String, action:UIAlertAction)
    {
        let alertController = UIAlertController(title: message, message: "Score:\(score)", preferredStyle: .alert)
        alertController.addAction(action)

        present(alertController, animated: true, completion: nil)
    }
    
   
}

