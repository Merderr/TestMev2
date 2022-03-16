//
//  ViewController.swift
//  TestMe2
//
//  Created by admin on 3/15/22.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var subscription: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    var db : OpaquePointer?
    var UserList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDetail.DB.sqllite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK{
            print("cant open data base")
        }
        
        if sqlite3_exec(db, "create table if not exists User (ID integer primary key autoincrement,Name text, Username text, Password Text, Subscription integer)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
}
    
    @IBAction func saveButton(_ sender: Any) {
        let  Name = name.text! as! NSString
        let  Username = username.text! as! NSString
                let  Pass = password.text as! NSString
                let  Sub = subscription.text as! NSString
                var stmt : OpaquePointer?
                let query = "insert into User (Name, Username, Password, Subscription) values (?,?,?,?)"
                
                if sqlite3_prepare_v2(db,query,-1,&stmt,nil) != SQLITE_OK {
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print(err)
                }
                if sqlite3_bind_text(stmt, 1, Name.utf8String, -1, nil) != SQLITE_OK {
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print(err)
                    
                }
        if sqlite3_bind_text(stmt, 2, Username.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_bind_text(stmt, 3, Pass.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        if sqlite3_bind_text(stmt, 4, Sub.utf8String, -1, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print(err)
                    
                }
                username.text = ""
                name.text = ""
                password.text = ""
                subscription.text = ""
                print("data saved")
            }
    

    @IBAction func viewButton(_ sender: Any) {
        UserList.removeAll()
                let query = "select * from User"
                var stmt : OpaquePointer?
                
                if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
                    let err = String(cString: sqlite3_errmsg(db)!)
                    print(err)
                    return
                }
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    let ID = sqlite3_column_int(stmt, 0)
                    let Name = String(cString: sqlite3_column_text(stmt, 1))
                    let Username = String(cString: sqlite3_column_text(stmt, 2))
                    let Password = String(cString: sqlite3_column_text(stmt, 3))
                    let Subscription = sqlite3_column_int(stmt, 4)
                    UserList.append(User(ID: Int(ID), Name: Name, Username: Username, Password: Password, Subscription: Int(Subscription)))
                    
                    
                }
                for list in UserList {
                    print("id is", list.ID,"name is", list.Name,"Username is", list.Username,"Password is", list.Password,"Subscription is", list.Subscription)
                }
    }
    
    
    @IBAction func userView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "userView") as! NextViewContoller
        self.presentedViewController(nextViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func adminView(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "adminView") as! NextViewContoller
        self.presentedViewController(nextViewController, animated: true, completion: nil)
    }
}

