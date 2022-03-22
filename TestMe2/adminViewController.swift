//
//  adminViewController.swift
//  TestMe2
//
//  Created by admin on 3/16/22.
//

import UIKit
import UserNotifications

class adminViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var userToBlock: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    }
    
    @IBAction func sendNotif(_ sender: Any) {
        UNUserNotificationCenter.current().getNotificationSettings{ notifS in
            switch notifS.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) {
                    granted , err in
                    if let error = err {
                        print("request failed", error)
                    }
                    self.generateNotification()
                }
            case .authorized:
                self.generateNotification()
            case .denied:
                print("Application not allowed")
            default:
                print("")
            }
        }
    }
    
    func generateNotification(){
        let ncont = UNMutableNotificationContent()
        ncont.title = "Test"
        ncont.subtitle = "From TestMe App"
        ncont.body = "A new quiz has been created, please come try it!"
        
        let ntrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        let nreq = UNNotificationRequest(identifier: "User_Local_notification", content: ncont, trigger: ntrigger)
        
        UNUserNotificationCenter.current().add(nreq) { err in
            if let error = err {
                print("Can not add notification request ", error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotificationSound, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
    
    @IBAction func userScoreView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userScore") as! userScoreViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func blockUser(_ sender: Any) {
        //if(userToBlock.text == username){
            
        //} else {
            print("Invalid user")
        }
    }

