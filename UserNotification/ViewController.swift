//
//  ViewController.swift
//  21 Notification
//
//  Created by Taha Saleh on 12/27/22.
//

import UIKit
import UserNotifications


class ViewController: UIViewController, UNUserNotificationCenterDelegate
{
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        center.delegate = self
        navigationItem.rightBarButtonItem = .init(title: "schedule", style: .plain, target: self, action: #selector(schedule))
        navigationItem.leftBarButtonItem = .init(title: "permission", style: .plain, target: self, action: #selector(askPermission))
      
    }

    @objc func askPermission()
    {
        center.requestAuthorization(options: [.alert,.badge,.sound])
         {(granted, error) in
          if granted
          {
              print("granted")
          }else
          {
              print(error?.localizedDescription ?? "error")
              
          }
      }
    }
    @objc func schedule()
    {
        
        registerCatergories()
        let content = UNMutableNotificationContent()
        center.removeAllPendingNotificationRequests()
        content.title = "late! wake up"
        content.subtitle = "early birds get the warm"
        content.sound = .default
        content.categoryIdentifier = "alarm"
        content.userInfo = ["email":"Tahasaleh58@gmail.com"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
        
    }
    
    func registerCatergories()
    {
        let show = UNNotificationAction(identifier: "draw", title: "tell me more...", options: .authenticationRequired)
        let catergory = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
        center.setNotificationCategories([catergory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let data = response.notification.request.content.userInfo["email"] as? String{
            print("email = \(data)")
            
            switch response.actionIdentifier
            {
            case UNNotificationDefaultActionIdentifier:
                print("default")
            case "draw":
                let view1 = UIView(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
                view1.backgroundColor = .green
                view.addSubview(view1)
            default:
                break
            }
        }
        completionHandler()
    }
}

