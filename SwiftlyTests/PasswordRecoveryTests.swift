//  INFO49635 - CAPSTONE FALL 2022
//  EditAccountTests.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import XCTest
@testable import Swiftly
@testable import Pods_Swiftly

import Firebase
import FirebaseFirestore

class PasswordRecoveryTests: XCTestCase {
    
    func testEmailValidationTrue(){
        let passwordRecoveryViewModel = PasswordRecoveryViewModel()
        
        passwordRecoveryViewModel.email = ""
        
        
        XCTAssertFalse(passwordRecoveryViewModel.isEmailValid())
    }
    
    func testEmailValidationFalse(){
        let passwordRecoveryViewModel = PasswordRecoveryViewModel()
        
        passwordRecoveryViewModel.email = "email@email.com"
        
        
        XCTAssertTrue(passwordRecoveryViewModel.isEmailValid())
    }

    func testEmailCheckFound(){
        let passwordRecoveryViewModel = PasswordRecoveryViewModel()
        let expectation = self.expectation(description: "EmailCheck")
        
        passwordRecoveryViewModel.email = "moktar@email.com"
        
        passwordRecoveryViewModel.checkIfEmailExists(emailChecked: passwordRecoveryViewModel.email){
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(passwordRecoveryViewModel.emailExists)
        
        
    }
    
    func testEmailCheckNotFound(){
        let passwordRecoveryViewModel = PasswordRecoveryViewModel()
        let expectation = self.expectation(description: "EmailCheck")
        
        passwordRecoveryViewModel.email = "emailnottiedtoaccount@email.com"
        
        passwordRecoveryViewModel.checkIfEmailExists(emailChecked: passwordRecoveryViewModel.email){
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertFalse(passwordRecoveryViewModel.emailExists)
        
        
    }
    
    
    func testPasswordRecoveryEmailSent(){
        let passwordRecoveryViewModel = PasswordRecoveryViewModel()
        let expectation = self.expectation(description: "RecoveryEmailCheck")
        
        passwordRecoveryViewModel.email = "moktar@email.com"
        
        passwordRecoveryViewModel.resetPassword(){
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(passwordRecoveryViewModel.result,"Success")
    }

}
