//
//  User.swift
//  Project2
//
//  Created by admin on 3/14/22.
//
import Foundation
class User{
    var ID : Int
    var Name : String?
    var Username : String?
    var Password : String?
    var Subscription : Int

    init(ID: Int , Name : String , Username : String , Password : String , Subscription : Int ){
        self.ID = ID
        self.Name = Name
        self.Username = Username
        self.Password = Password
        self.Subscription = Subscription
    }
}
