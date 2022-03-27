//
//  userViewController.swift
//  TestMe2
//
//  Created by admin on 3/16/22.
//

import UIKit
import SQLite3

class userViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userRankingView: UITableView!
    @IBOutlet weak var welcome: UILabel!
    var count: Int = 0
    var userList = [User]()
    var stmt : OpaquePointer?
    var db : OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK{
            print("cant open data base")
        }
        
        if sqlite3_exec(db, "create table if not exists User (ID integer primary key autoincrement,Fname text,Lname text, Email text,Username text, Password Text, Subscription integer)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        if sqlite3_exec(db, "create table if not exists TempVariables (tempUser text primary key, tempPass text)", nil, nil, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db)!)
            print("no error",err)
        }
        
        let query = "select * from User inner join TempVariables on TempVariables.tempUser = User.Username; inner join TempVariables on TempVariables.tempPass = User.Password"
        
        
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //the users info
            let id = sqlite3_column_int(stmt, 0)
            let firstN = String(cString: sqlite3_column_text(stmt, 1))
            let lastN = String(cString: sqlite3_column_text(stmt, 2))
            let eMail = String(cString: sqlite3_column_text(stmt, 3))
            let userN = String(cString: sqlite3_column_text(stmt, 4))
            let passW = String(cString: sqlite3_column_text(stmt, 5))
            let blocked = String(cString: sqlite3_column_text(stmt, 6))
            let subS = sqlite3_column_int(stmt, 7)
            let score = sqlite3_column_int(stmt, 8)

            userList.append(User(ID: Int(id), Email: eMail, FirstName: firstN, LastName: lastN, Username: userN, Password: passW, Subscription: Int(subS), Blocked: blocked, Score: Int(score)))
            welcome.text = (firstN)
            //for u in userList{
              //  if (u.Subscription != 1){
              //  count = 0
              //  }
            //}
        }
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        var stmt : OpaquePointer?
        let query = "delete from TempVariables"
        
        if sqlite3_prepare(db, query, -2, &stmt, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
        }
        if sqlite3_step(stmt) != SQLITE_DONE {
            let err = String(cString: sqlite3_errmsg(db)!)
            print(err)
            
        }
        performSegue(withIdentifier: "gologout", sender: sender)
    }
    
    
    
    @IBAction func sendtoJava(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "javaQuiz") as! javaQViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func sendtoSwift(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "swiftQuiz") as! swiftQViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func sendtoCPlusPlus(_ sender: Any) {
        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "cplusplusQuiz") as! cplusplusQViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userRankingView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Username: " + userList[indexPath.row].Username! + ", Score:" + String(userList[indexPath.row].Score)
        return cell
    }
}

extension UIButton {
    func preventRepeatedPresses(inNext seconds: Double = 15) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}
