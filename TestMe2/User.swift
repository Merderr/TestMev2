//
//  User.swift
//  Project2
//
//  Created by admin on 3/14/22.
//

import Foundation

//Create struct for User
class User {
    var ID : Int
    var Email : String?
    var FirstName : String?
    var LastName : String?
    var Username : String?
    var Password : String?
    var Subscription : Int
    var Blocked : String?
    var cplusplusScore : Int
    var swiftScore : Int
    var javaScore : Int
    
    //Initialize user to default values
    init(ID: Int , Email : String ,FirstName : String ,LastName : String , Username : String , Password : String , Subscription : Int, Blocked : String, cplusplusScore: Int,swiftScore: Int, javaScore: Int){
        self.ID = ID
        self.Email = Email
        self.FirstName = FirstName
        self.LastName = LastName
        self.Username = Username
        self.Password = Password
        self.Subscription = Subscription
        self.Blocked = Blocked
        self.cplusplusScore = cplusplusScore
        self.swiftScore = swiftScore
        self.javaScore = javaScore
    }
}
