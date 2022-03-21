//
//  TestMe2Tests.swift
//  TestMe2Tests
//
//  Created by admin on 3/16/22.
//

import XCTest
@testable import TestMe2

class TestMe2Tests: XCTestCase {

    let valid = Validate()
    func testValidation_Returns_true_TFNotEmpty(){
        XCTAssertTrue(valid.validation(email: "test@gmail.com", user: "test", pass: "123", fname: "firstname", lname: "lastname"))
    }
    
    func testValidation_Return_false_TFAreEmpty(){
        XCTAssertFalse(valid.validation(email: "", user: "", pass: "", fname: "", lname: ""))
    }

}
