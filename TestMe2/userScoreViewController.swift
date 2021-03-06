//
//  userScoreViewController.swift
//  TestMe2
//
//  Created by admin on 3/16/22.
//

import UIKit
import SQLite3

class userScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Link tableview to swift file
    @IBOutlet weak var userScoreTable: UITableView!
    
    //Create parameter variables for SQLite database connection and queries
    var db : OpaquePointer?
    var user : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Open SQLite file
        let fileP = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserDB.sqlite")
        print("db path is ", fileP)
        
        if sqlite3_open(fileP.path, &db) != SQLITE_OK {
            print("cant open data base")
        }
        
        //Query statement to select info from User Table
        let queryString = "Select * from User"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let Uname = String(cString: sqlite3_column_text(stmt, 4))
            let cplusplusscore = sqlite3_column_int(stmt, 8)
            let swiftscore = sqlite3_column_int(stmt, 9)
            let javascore = sqlite3_column_int(stmt, 10)
            //Assign values to instance variables and write values to view controller controls
            user.append(User(ID: Int(id), Email: "", FirstName: "", LastName: "", Username: Uname, Password: "", Subscription: 0, Blocked: "", cplusplusScore: Int(cplusplusscore), swiftScore: Int(swiftscore), javaScore: Int(javascore)))
        }
        self.userScoreTable.reloadData()
    }
    
    //Auto size the tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //Display how many users
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    //Create cell and add Username and quiz scores
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userScoreTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = "Username: " + user[indexPath.row].Username! + "\n" + "C++ Score: " + String(user[indexPath.row].cplusplusScore) + "\n" + "Swift Score: " + String(user[indexPath.row].swiftScore) + "\n" + "Java Score: " + String(user[indexPath.row].javaScore)
        return cell
    }
}
