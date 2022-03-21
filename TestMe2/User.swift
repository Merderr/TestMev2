//
//  User.swift
//  Project2
//
//  Created by admin on 3/14/22.
//
import Foundation
class User{
    var ID : Int
    var Email : String?
    var FirstName : String?
    var LastName : String?
    var Username : String?
    var Password : String?
    var Subscription : Int

    init(ID: Int , Email : String ,FirstName : String ,LastName : String , Username : String , Password : String , Subscription : Int ){
        self.ID = ID
        self.Email = Email
        self.FirstName = FirstName
        self.LastName = LastName
        self.Username = Username
        self.Password = Password
        self.Subscription = Subscription
    }
}
