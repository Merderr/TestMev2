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
    
    //Outlet references for view controller controls. Data to be captured for SQLite read/write purposes
    @IBOutlet weak var subSwitch: UISwitch!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var Fname: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lgbtn: FBLoginButton!
    
    //Create parameter variables and empty User array for SQLite database connection and queries
    var db : OpaquePointer?
    var UserList = [User]()
    
    //Check if user is subscribed and assign them value of 1 if true
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
    
    //Update switch label text based on subscription status
    func updateSwitch(){
        if subSwitch.isOn{
            subLabel.text = "Subscribed"
        }
        else{
            subLabel.text = "Unsubscribed"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Facebook token to remember log in
        if let token = AccessToken.current, !token.isExpired{
            let token = token.tokenString
            let req = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
            req.start{
                conne, result, error in
                print(result)
            }
        } else {
            self.lgbtn.delegate = self
            lgbtn.permissions = ["public_public", "email"]
        }
        
        //Creation of SQLite file
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK{
            print("cant open data base")
        }
        
        //Create User Table
        if sqlite3_exec(db, "create table if not exists User (ID INTEGER primary key autoincrement,Fname TEXT,Lname TEXT, Email TEXT,Username TEXT, Password TEXT, Subscription integer, Blocked TEXT, cplusplusScore integer, swiftScore integer, javaScore integer)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        
        //Create Temp variables table to store variables for holding info
        if sqlite3_exec(db, "create table if not exists TempVariables (ID INTEGER primary key,Fnametemp TEXT,Lnametemp TEXT, Emailtemp TEXT,tempUser TEXT, tempPass TEXT, Subscriptiontemp integer, Blocked TEXT, cplusplusScoretemp INTEGER, swiftScoretemp INTEGER, javaScoretemp INTEGER)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        
        //Create swift question table to display questions, answer options and save results
        if sqlite3_exec(db, "create table if not exists swiftQuestions (Number TEXT primary key, QuestionText TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, CorrectAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        
        //Create C++ question table to display questions, answer options and save results
        if sqlite3_exec(db, "create table if not exists cplusplusQuestions (Number TEXT primary key, QuestionText TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, CorrectAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        
        //Create Java question table to display questions, answer options and save results
        if sqlite3_exec(db, "create table if not exists javaQuestions (Number TEXT primary key, QuestionText TEXT, AnswerA TEXT, AnswerB TEXT, AnswerC TEXT, AnswerD TEXT, CorrectAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        
        //Create Answer table to hold answer results
        if sqlite3_exec(db, "create table if not exists Answers (Email TEXT primary key, FirstName TEXT, LastName TEXT, Quiz TEXT, QuestionNumber TEXT, QuestionAnswer TEXT)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
    }
    
    //Save user data via opening User table and saving fields accordingly
    @IBAction func saveButton(_ sender: Any) {
        
        let  firstn = Fname.text! as! NSString
        let  lastn = Lname.text! as! NSString
        let  mail = email.text! as! NSString
        let  usern = username.text! as! NSString
        let  passw = password.text as! NSString
        let  subsc = subSwitch.isOn as! NSNumber
        
        //Set blocked to default false but can be true once admin blocks user
        let blocked = "false"
        var stmt : OpaquePointer?
        
        //Query to insert data into User table
        let query = "insert into User (Fname, Lname, Email, Username, Password, Subscription, Blocked) values (?,?,?,?,?,?,?)"
        
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
        if sqlite3_bind_text(stmt, 7, blocked, -1, nil) != SQLITE_OK {
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
    }
    
    //Create FB login button with two extra functions to satisfy FBLoginButtonDelegate
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let req = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
        req.start{
            conne, result, error in
            print(result)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
    @IBAction func loginfb(_ sender: Any) {
    }
    
    //Send user to user login view once clicked
    @IBAction func userView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userLoginView") as! userLoginViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    //Send admin to admin login view once clicked
    @IBAction func adminView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "adminLoginView") as! adminLoginViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
}



