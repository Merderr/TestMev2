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
    
    @IBOutlet weak var userToBlock: UITextField!
    
    //Create parameter variables for SQLite database connection and queries
    var user = [User]()
    var db : OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigning User Notification
        UNUserNotificationCenter.current().delegate = self
        
        //Open SQlite file
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK{
            print("cant open data base")
        }
    }
    
    //Send notification to user via banner
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
    
    //Create notification message, timer and trigger
    func generateNotification(){
        let ncont = UNMutableNotificationContent()
        ncont.title = "Test"
        ncont.subtitle = "From TestMe App"
        ncont.body = "A new quiz has been created, please come try it!"
        
        let ntrigger = UNTimeIntervalNotificationTrigger(timeInterval: 7.0, repeats: false)
        let nreq = UNNotificationRequest(identifier: "User_Local_notification", content: ncont, trigger: ntrigger)
        
        UNUserNotificationCenter.current().add(nreq) { err in
            if let error = err {
                print("Can not add notification request ", error)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
    
    //Send admin to user score ranking table
    @IBAction func userScoreView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userScore") as! userScoreViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    //Block user via email by typing in text box
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
                    let cplusplusscore = sqlite3_column_int(stmt, 8)
                    let swiftscore = sqlite3_column_int(stmt, 9)
                    let javascore = sqlite3_column_int(stmt, 10)
                    user.append(User(ID: Int(id), Email: email, FirstName: firstN, LastName: lastN, Username: userN, Password: passW, Subscription: Int(subS), Blocked: blocked, cplusplusScore: Int(cplusplusscore), swiftScore: Int(swiftscore), javaScore: Int(javascore)))
                }
                
                let blocked = "true"
                let email = String(cString: sqlite3_column_text(queryStatement, 3))
                if (email == userToBlock.text){
                    var stmt : OpaquePointer?
                    var email = "test324@gmail.com" as NSString
                    
                    let query = "UPDATE User SET Blocked = 'true' WHERE Email = '\(email)'"
                    
                    if sqlite3_prepare_v2(db,query,-1,&stmt,nil) == SQLITE_OK {
                        print("inside sqlite okay")
                        let err = String(cString: sqlite3_errmsg(db)!)
                        if sqlite3_step(stmt) == SQLITE_DONE {
                            print("inside sqlite done")
                            let err = String(cString: sqlite3_errmsg(db)!)
                            print(err)
                        }
                        print(err)
                    }
                    sqlite3_finalize(stmt)
                }
            }
        }
        
        //Send dialog to admin to let user has been blcoked
        var dialogMessage = UIAlertController(title: "Attention", message: "User has been blocked!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler:  {
            (action) -> Void in
            print("Ok button tapped")
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
