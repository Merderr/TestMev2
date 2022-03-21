//
//  DBHelper.swift
//  TestMe2
//
//  Created by admin on 3/20/22.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(ID INTEGER PRIMARY KEY,email TEXT, firstname TEXT, lastname TEXT, username TEXT, password TEXT, subscription INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user score table created.")
            } else {
                print("user score table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(ID: Int, email: String, FirstName: String, LastName: String, Username: String, Password: String, Subscription: Int) {
        let users = read()
        for u in users
        {
            if u.ID == ID
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO user (id, email, firstname, lastname, username, password, subscription) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 0, Int32(ID))
            sqlite3_bind_text(insertStatement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (FirstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (LastName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (Username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (Password as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, Int32())
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [User] {
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer? = nil
        var psns : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let fName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let lName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let userName = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let pass = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let sub = sqlite3_column_int(queryStatement, 6)
                psns.append(User(ID: Int(id), Email: String(email), FirstName: String(fName), LastName: String(lName), Username: String(userName), Password: String(pass), Subscription: Int(sub), questionNumber: 0))
                print("Query Result:")
                print("\(id) | \(email) | \(sub)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM user WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
