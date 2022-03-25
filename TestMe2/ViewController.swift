//
//  ViewController.swift
//  TestMe2
//
//  Created by admin on 3/15/22.
//

import UIKit
import SQLite3
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var subSwitch: UISwitch!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var Fname: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lgbtn: FBLoginButton!
    @IBAction func subCheck(_ sender: Any) {
        updateSwitch()
        var isSubscribed: Int = 0
        
        if subSwitch.isOn{
            isSubscribed = 1
        }
        else{
            isSubscribed = 0
        }
    }
    func updateSwitch(){
        if subSwitch.isOn{
            subLabel.text = "Subscribed"
        }
        else{
            subLabel.text = "Unsubscribed"
        }
        
    }
    
    var db : OpaquePointer?
    var UserList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = AccessToken.current, !token.isExpired{
            let token = token.tokenString
            
            let req = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
            req.start{
                conne, result, error in
                print(result)
            }
        } else {
            //let loginbtn = FBLoginButton()
            //loginbtn.center = view.center
            //view.addSubview(loginbtn)
            self.lgbtn.delegate = self
            lgbtn.permissions = ["public_public", "email"]
        }
        
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK{
            print("cant open data base")
        }
        
        if sqlite3_exec(db, "create table if not exists User (ID INTEGER primary key autoincrement,Fname TEXT,Lname TEXT, Email TEXT,Username TEXT, Password TEXT, Subscription integer, Blocked text, cplusplusScore integer, swiftScore integer, javaScore integer)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        if sqlite3_exec(db, "create table if not exists TempVariables (ID INTEGER primary key autoincrement,Fnametemp TEXT,Lnametemp TEXT, Emailtemp TEXT,tempUser TEXT, tempPass TEXT, Subscriptiontemp integer, Blocked text, cplusplusScoretemp integer, swiftScoretemp integer, javaScoretemp integer)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        if sqlite3_exec(db, "create table if not exists swiftQuestions (Number TEXT primary key, QuestionText TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, CorrectAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        if sqlite3_exec(db, "create table if not exists cplusplusQuestions (Number TEXT primary key, QuestionText TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, CorrectAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        if sqlite3_exec(db, "create table if not exists javaQuestions (Number TEXT primary key, QuestionText TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, CorrectAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        if sqlite3_exec(db, "create table if not exists Answers (Email TEXT primary key, FirstName TEXT, LastName TEXT, Quiz TEXT, QuestionNumber TEXT, QuestionAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let  firstn = Fname.text! as! NSString
        let  lastn = Lname.text! as! NSString
        let  mail = email.text! as! NSString
        let  usern = username.text! as! NSString
        let  passw = password.text as! NSString
        let  subsc = subSwitch.isOn as! NSNumber
        var stmt : OpaquePointer?
        let query = "insert into User (Fname, Lname, Email, Username, Password, Subscription) values (?,?,?,?,?,?)"
        
        if sqlite3_prepare_v2(db,query,-1,&stmt,nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
        if sqlite3_bind_text(stmt, 1, firstn.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_bind_text(stmt, 2, lastn.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_bind_text(stmt, 3, mail.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_bind_text(stmt, 4, usern.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_bind_text(stmt, 5, passw.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_bind_int(stmt, 6, Int32(subsc.uint32Value)) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        Fname.text = ""
        Lname.text = ""
        email.text = ""
        username.text = ""
        password.text = ""
        subSwitch.isOn = false
        print("data saved")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let req = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
        req.start{
            conne, result, error in
            print(result)
        }
    }
    
    @IBAction func loginfb(_ sender: Any) {
    }
    
    
    @IBAction func userView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userLoginView") as! userLoginViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func adminView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "adminLoginView") as! adminLoginViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
}



