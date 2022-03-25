//
//  adminViewController.swift
//  TestMe2
//
//  Created by admin on 3/16/22.
//

import UIKit
import UserNotifications
import SQLite3

class adminViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var user = [User]()
    var db : OpaquePointer?
    
    @IBOutlet weak var userToBlock: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK{
            print("cant open data base")
        }
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
        
        let ntrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
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
        var queryStatement: OpaquePointer?
        var stmt : OpaquePointer?
        let queryStatementString = "Select * From User;"
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    let id = sqlite3_column_int(stmt, 0)
                    let firstN = String(cString: sqlite3_column_text(stmt, 1))
                    let lastN = String(cString: sqlite3_column_text(stmt, 2))
                    let email = String(cString: sqlite3_column_text(stmt, 3))
                    let userN = String(cString: sqlite3_column_text(stmt, 4))
                    let passW = String(cString: sqlite3_column_text(stmt, 5))
                    let subS = sqlite3_column_int(stmt, 6)
                    let blocked = String(cString: sqlite3_column_text(stmt, 7))
                    let qNum = sqlite3_column_int(stmt, 8)
                    let score = sqlite3_column_int(stmt, 9)
                    user.append(User(ID: Int(id), Email: email, FirstName: firstN, LastName: lastN, Username: userN, Password: passW, Subscription: Int(subS), Blocked: blocked, Score: Int(score)))
                }
                
                let id = sqlite3_column_int(queryStatement, 0)
                
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 4) else {
                    print("Query result is nil")
                    return
                }
                let name = String(cString: queryResultCol1)
                if (name == userToBlock.text){
                    print("block")
                } else {
                    print("not blocked")
                }
            } else {
                print("\nQuery returned no results.")
            }
        } else {
            
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        
        sqlite3_finalize(queryStatement)
        
    }
}

