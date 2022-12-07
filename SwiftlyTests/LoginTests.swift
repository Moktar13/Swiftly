//  INFO49635 - CAPSTONE FALL 2022
//  LoginTests.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import XCTest
@testable import Swiftly
@testable import Pods_Swiftly

import FirebaseFirestore

class LoginTests: XCTestCase {
    
    // Testing: Invalid login credentials
    func testInvalidLogin() {
        
        let loginViewModel = LoginViewModel()
        
        let expectation = self.expectation(description: "Login")
        
        loginViewModel.loginUser(email: "", password: "", completion: { _ in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(loginViewModel.isSuccessful)
    }
    
    // Testing: Valid login credentials
    func testValidLogin() throws {

        let loginViewModel = LoginViewModel()
        
        let expectation = self.expectation(description: "Login")
        
        // Note: email and password might have to be changed
        loginViewModel.loginUser(email: "dummy@email.com", password: "Dummy123", completion: { _ in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(loginViewModel.isSuccessful)
    }
    
    // Testing: Download progress for user
    func testUserProgressDownload() throws {
        let loginViewModel = LoginViewModel()
        let chaptersViewModel = ChaptersViewModel()
        let expectation = self.expectation(description: "UserProgress")
        expectation.assertForOverFulfill = false
        
        chaptersViewModel.chaptersArr.removeAll()
        chaptersViewModel.clearAllData()
        
        chaptersViewModel.downloadChapters { _ in
            chaptersViewModel.organizeChaptersByNumber {
                chaptersViewModel.retrieveUserbaseCompletion { _ in
                    loginViewModel.loginUser(email: "dummy@email.com", password: "Dummy123") { _ in
                        chaptersViewModel.startUserDownload(email: "dummy@email.com") { status in
                            switch status {
                            case .success:
                                chaptersViewModel.isUserLoggedIn = true
                            case .failure:
                                print("Something went wrong...")
                            }
                            expectation.fulfill()
                        }
                    }
                }
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(chaptersViewModel.isUserLoggedIn, true)
    }
}
