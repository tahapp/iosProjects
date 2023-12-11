//
//  ViewController.swift
//  28 Secret Swift
//
//  Created by Taha Saleh on 1/12/23.
//

import UIKit
import LocalAuthentication
class ViewController: UIViewController
{
    
    @IBOutlet weak var secret: UITextView!
    let key = "SecretMessage"
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "nothing to see here"
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
      
        
    }
    @IBAction func authenticateUser(_ sender: UIButton)
    {
        
        let context = LAContext()
        
        var error : NSError?
       
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            let reason = "Identify yourself"
            // run authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ [weak self]
                (success, error) in
                
                DispatchQueue.main.async {
                    if success
                    {
                        self?.unlock()
                    }
                    else
                    {
                        self?.errorRaise(title: "Authentication failed", message: "you could not be verfied")
                    }
                }
            }
        }
        else
        {
            errorRaise(title: "Biometery Unavaiable", message: "your device does not have any biometery capability")
        }
        
        
    }
    
    @objc func adjustKeyboard(_ notification: Notification)
    {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{return}
        let actualKeyBoardSize = keyboardValue.cgRectValue
        let relativeKeyBoardSize = view.convert(actualKeyBoardSize,from:view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification
        {
            secret.contentInset = .zero
        }else
        {
            secret.contentInset = .init(top: 0, left: 0, bottom: relativeKeyBoardSize.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlock()
    {
       
        secret.isHidden = false
        title = "secret Stuff"
        
        if let text = KeychainWrapper.standard.string(forKey: key)
        {
            secret.text = text
        }
        
        
    }
    
    @objc func save()
    {
        guard secret.isHidden == false else{return}
        KeychainWrapper.standard.set(secret.text, forKey: key)
        secret.resignFirstResponder()
        
        secret.isHidden = true
        title = "nothing to see here"
    }
    
    func errorRaise(title:String,message:String?)
    {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        present(ac, animated: true)
    }
}



