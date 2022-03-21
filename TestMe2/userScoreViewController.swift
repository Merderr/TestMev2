//
//  userScoreViewController.swift
//  TestMe2
//
//  Created by admin on 3/16/22.
//

import UIKit

class userScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userScoreTable: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    var db: DBHelper = DBHelper()
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userScoreTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        userScoreTable.delegate = self
        userScoreTable.dataSource = self
        
        
        db.insert(ID: 001, email: "test@gmail.com", FirstName: "UserFirstName", LastName: "UserLastName", Username: "Username1", Password: "123", Subscription: 1)
        
        users = db.read()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        //cell.textLabel?.text = "ID : " + users[indexPath.row].ID! + "Email: " + String(users[indexPath.row].Email!) + "First Name: " + String(users[indexPath.row].fName!) + "Last Name: " + String(users[indexPath.row].lName!) + "User Name: " + String(users[indexPath.row].Username!) + "Password: " + String(users[indexPath.row].Password!) + "Subscription: " + users[indexPath.row].Subscription!)
        cell.textLabel?.text = "Email: " + String(users[indexPath.row].Email!)
        
        return cell
    }
}
    
