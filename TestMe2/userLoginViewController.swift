//
//  userLoginViewController.swift
//  TestMe2
//
//  Created by admin on 3/16/22.
//

import UIKit
import SQLite3

class userLoginViewController: UIViewController {
    
    var userList = [User]()
    var db : OpaquePointer?
    
    @IBOutlet weak var loginuser: UITextField!
    @IBOutlet weak var loginpass: UITextField!
    @IBOutlet weak var subSwitch: UISwitch!
    @IBOutlet weak var subLabel: UILabel!
    @IBAction func subCheck(_ sender: Any) {
        updateSwitch()
        var isSubscribed: Int = 0
        if subSwitch.isOn{
            isSubscribed = 1
        } else{
            isSubscribed = 0
        }
    }
    
    func updateSwitch(){
        if subSwitch.isOn{
            subLabel.text = "Subscribed"
        } else{
            subLabel.text = "Unsubscribed"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK{
            print("cant open data base")
        }
    }		
    
    @IBAction func loginButton(_ sender: Any) {
        let  tempUser = loginuser.text! as! NSString
        let  tempPass = loginpass.text! as! NSString
        //let  subsc = subSwitch.isOn as! NSNumber
        
        if tempUser == "" || tempPass == ""{
            print("empty input fields")
        } else{
            //if blank fields
            //if info not in database
            //else do the stuff
            
            var stmt : OpaquePointer?
            let loginquery = "insert into TempVariables (tempUser, tempPass) values (?,?)"
            
            if sqlite3_prepare_v2(db,loginquery,-1,&stmt,nil) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
            }
            if sqlite3_bind_text(stmt, 1, tempUser.utf8String, -1, nil) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
            }
            if sqlite3_bind_text(stmt, 2, tempPass.utf8String, -1, nil) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
            }
            if sqlite3_step(stmt) != SQLITE_DONE {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
            }
            //if sqlite3_bind_int(stmt, 6, Int32(subsc.uint32Value)) != SQLITE_OK {
            //    let err = String(cString: sqlite3_errmsg(db)!)
            //   print(err)
            //}
            
            //subSwitch.isOn = false
            
            
            
            let updatequery = "Update TempVariables SET Fnametemp = (SELECT User.Fname from User WHERE User.Username = TempVariables.tempUser),Lnametemp = (SELECT User.Lname from User WHERE User.Username = TempVariables.tempUser),Emailtemp = (SELECT User.Email from User WHERE User.Username = TempVariables.tempUser),Subscriptiontemp = (SELECT User.Subscription from User WHERE User.Username = TempVariables.tempUser) WHERE EXISTS (SELECT * FROM User WHERE User.Username = TempVariables.tempUser)"
            
            if sqlite3_prepare_v2(db,updatequery,-1,&stmt,nil) != SQLITE_OK {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
            }
           
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
                
            }
            
            
            
            
            
            let query = "select * from User inner join TempVariables on TempVariables.tempUser = User.Username; inner join TempVariables on TempVariables.tempPass = User.Password"
            
            
            if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                let err = String(cString: sqlite3_errmsg(db)!)
                print(err)
                return
            }
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = sqlite3_column_int(stmt, 0)
                let firstN = String(cString: sqlite3_column_text(stmt, 1))
                let lastN = String(cString: sqlite3_column_text(stmt, 2))
                let eMail = String(cString: sqlite3_column_text(stmt, 3))
                let userN = String(cString: sqlite3_column_text(stmt, 4))
                let passW = String(cString: sqlite3_column_text(stmt, 5))
                let subS = sqlite3_column_int(stmt, 6)
                let blocked = String(cString: sqlite3_column_text(stmt, 7))
                let qNum = sqlite3_column_int(stmt, 8)
                let score = sqlite3_column_int(stmt, 9)
                userList.append(User(ID: Int(id), Email: eMail, FirstName: firstN, LastName: lastN, Username: userN, Password: passW, Subscription: Int(subS), Blocked: blocked, Score: Int(score)))
                
            }
            for list in userList {
                if (loginuser.text == list.Username!) && (loginpass.text == list.Password!){
                    let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userView") as! userViewController
                    self.present(nextViewController, animated: true, completion: nil)
                } else if (loginuser.text == list.Username!) && (loginpass.text != list.Password!){
                    var dialogMessage = UIAlertController(title: "Attention", message: "Invalid password, please check and try again.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler:  {
                        (action) -> Void in
                        print("Ok button tapped")
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                } else if (loginuser.text != list.Username!) && (loginpass.text == list.Password!){
                    var dialogMessage = UIAlertController(title: "Attention", message: "Invalid username, please check and try again.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler:  {
                        (action) -> Void in
                        print("Ok button tapped")
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                } else {
                    var dialogMessage = UIAlertController(title: "Attention", message: "Invalid username and password, please check and try again.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler:  {
                        (action) -> Void in
                        print("Ok button tapped")
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                }
                
            }
            
        }
    }
}

