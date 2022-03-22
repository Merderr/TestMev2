//
//  Validate.swift
//  TestMe2Tests
//
//  Created by admin on 3/17/22.
//
//test


import Foundation
import Foundation

class Validate {
    func validation(email: String, user: String, pass: String, fname: String, lname: String) -> Bool {
        if (email != "") && (user != "") && (pass != "") && (fname != "") && (lname != "") {
            return true
        } else {
            return false
        }
    }
}
