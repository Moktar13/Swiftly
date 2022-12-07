//  INFO49635 - CAPSTONE FALL 2022
//  EditAccountTests.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import XCTest
@testable import Swiftly
@testable import Pods_Swiftly

import Firebase
import FirebaseFirestore

class EditAccountTests: XCTestCase {

    func testInvalidAccountEdit(){
        let userAccountViewModel = UserAccountViewModel()
        
        
        //creating test user for filling in logged in data used for updating account information
        userAccountViewModel.loggedInUser.firstName = "testFirstName"
        userAccountViewModel.loggedInUser.lastName = "testLastName"
        userAccountViewModel.loggedInUser.username = "testAccount"
        userAccountViewModel.loggedInUser.email = "testcreateaccount@email.com"
        userAccountViewModel.loggedInUser.password = "Password12"
        userAccountViewModel.loggedInUser.dob = "01/01/2000"
        userAccountViewModel.loggedInUser.country = "Canada"
        
        userAccountViewModel.updatedUser.firstName = ""
        userAccountViewModel.updatedUser.lastName = ""
        userAccountViewModel.updatedUser.username = "testAccount"
        userAccountViewModel.updatedUser.email = "testcreateaccount@email.com"
        userAccountViewModel.updatedUser.password = ""
        userAccountViewModel.updatedUser.dob = ""
        userAccountViewModel.updatedUser.country = "Canada"
        
        
        //all the editable fields are still empty, failing the vaildation checks, making editing NOT complete,therefore false on boolean check
        XCTAssertFalse(userAccountViewModel.isEditingComplete)
        
        
    }
    
    func testValidAccountEdit(){
        let userAccountViewModel = UserAccountViewModel()
        
        
        //creating test user for filling in logged in data used for updating account information
        userAccountViewModel.loggedInUser.firstName = "testFirstName"
        userAccountViewModel.loggedInUser.lastName = "testLastName"
        userAccountViewModel.loggedInUser.username = "testAccount"
        userAccountViewModel.loggedInUser.email = "testcreateaccount@email.com"
        userAccountViewModel.loggedInUser.password = "Password12"
        userAccountViewModel.loggedInUser.dob = "01/01/2000"
        userAccountViewModel.loggedInUser.country = "Canada"
        
        //performing test edit where fields are updated to make changes to users account
        userAccountViewModel.updatedUser.firstName = "testFirstNameChange"
        userAccountViewModel.updatedUser.lastName = "testLastNameChange"
        userAccountViewModel.updatedUser.username = "testAccount"
        userAccountViewModel.updatedUser.email = "testcreateaccount@email.com"
        userAccountViewModel.updatedUser.password = "Password123"
        userAccountViewModel.updatedUser.dob = "02/02/2001"
        userAccountViewModel.updatedUser.country = "United States"
        
        
        //since all fields are filled in and meet validation requirements, editing is complete, therefore true on boolean check
        XCTAssertTrue(userAccountViewModel.isEditingComplete)
        
        
    }
    
    func testAccountEdit(){
        let userAccountViewModel = UserAccountViewModel()
        let loginViewModel = LoginViewModel()
        let expectation = self.expectation(description: "AccountEdit")

        loginViewModel.loginUser(email: "editacctest@email.com", password: "Password12", completion: { _ in
            
            userAccountViewModel.loggedInUser.firstName = "Edit"
            userAccountViewModel.loggedInUser.lastName = "Account"
            userAccountViewModel.loggedInUser.username = "EditAccTest"
            userAccountViewModel.loggedInUser.email = "editacctest@email.com"
            userAccountViewModel.loggedInUser.password = "Password12"
            userAccountViewModel.loggedInUser.dob = "01/01/2000"
            userAccountViewModel.loggedInUser.country = "Canada"
            
            userAccountViewModel.updatedUser.firstName = "Edit"
            userAccountViewModel.updatedUser.lastName = "Account"
            userAccountViewModel.updatedUser.username = "EditAccTest"
            userAccountViewModel.updatedUser.email = "editacctest@email.com"
            userAccountViewModel.updatedUser.password = "Password12"
            userAccountViewModel.updatedUser.dob = "01/01/2000"
            userAccountViewModel.updatedUser.country = "Canada"
            
            userAccountViewModel.updateAccount {
                expectation.fulfill()
            }
        })

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(userAccountViewModel.result, "success")
    }
    
    func testLogout(){
        let userAccountViewModel = UserAccountViewModel()
        
        
        //calling logoutUser() function used to clear logged in information
        userAccountViewModel.logoutUser()
        
        
        //successful logout updates the logoutSuccessful boolean to true, which is used to validate the result of this unit test
        XCTAssertTrue(userAccountViewModel.logoutSuccessful)
    }

}
