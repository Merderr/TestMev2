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
            let email = String(cString: sqlite3_column_text(stmt, 3))
            let userN = String(cString: sqlite3_column_text(stmt, 4))
            let passW = String(cString: sqlite3_column_text(stmt, 5))
            let subS = sqlite3_column_int(stmt, 6)
            let blocked = String(cString: sqlite3_column_text(stmt, 7))
            let cplusplusscore = sqlite3_column_int(stmt, 8)
            let swiftscore = sqlite3_column_int(stmt, 9)
            let javascore = sqlite3_column_int(stmt, 10)
            userList.append(User(ID: Int(id), Email: email, FirstName: firstN, LastName: lastN, Username: userN, Password: passW, Subscription: Int(subS), Blocked: blocked, cplusplusScore: Int(cplusplusscore), swiftScore: Int(swiftscore), javaScore: Int(javascore)))
            
            welcome.text = (firstN)
            
            for u in userList{
                if (u.Subscription != 1){
                    count = 0
                }
            }
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
    
    @IBOutlet weak var sendtoJava: UIButton!
    func enableButton() {
        self.sendtoJava.isEnabled = true
    }
    
    @IBAction func sendtoJava(_ sender: UIButton) {
        let query = "select * from User"
        
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
            let email = String(cString: sqlite3_column_text(stmt, 3))
            let userN = String(cString: sqlite3_column_text(stmt, 4))
            let passW = String(cString: sqlite3_column_text(stmt, 5))
            let subS = sqlite3_column_int(stmt, 6)
            let blocked = String(cString: sqlite3_column_text(stmt, 7))
            let cplusplusscore = sqlite3_column_int(stmt, 8)
            let swiftscore = sqlite3_column_int(stmt, 9)
            let javascore = sqlite3_column_int(stmt, 10)
            userList.append(User(ID: Int(id), Email: email, FirstName: firstN, LastName: lastN, Username: userN, Password: passW, Subscription: Int(subS), Blocked: blocked, cplusplusScore: Int(cplusplusscore), swiftScore: Int(swiftscore), javaScore: Int(javascore)))
            
            for u in userList {
                    if count < 2 && u.Subscription == 0{
                        let nextViewController = storyboard?.instantiateViewController(withIdentifier: "javaQuiz") as! javaQViewController
                        self.present(nextViewController, animated: true, completion: nil)
                        self.sendtoJava.isEnabled = false
                        count += 1
                        print(count)
            } else if count == 2 {
                Timer.scheduledTimer(timeInterval: 86400, target: self, selector: "enableButton", userInfo: nil, repeats: false)
            } else {
                let nextViewController = storyboard?.instantiateViewController(withIdentifier: "javaQuiz") as! javaQViewController
                self.present(nextViewController, animated: true, completion: nil)
            }
        }
    }
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
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = "Username: " + userList[indexPath.row].Username! + "\n" + "C++ Score: " + String(userList[indexPath.row].cplusplusScore) + "\n" + "Swift Score: " + String(userList[indexPath.row].swiftScore) + "\n" + "Java Score: " + String(userList[indexPath.row].javaScore)
            return cell
            
        }
        
    }
    
