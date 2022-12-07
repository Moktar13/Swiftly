//  INFO49635 - CAPSTONE FALL 2022
//  UpdatingProgressTests.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import XCTest
@testable import Swiftly
@testable import Pods_Swiftly

class UpdatingProgressTests: XCTestCase {
    
    func testUpdatingUserChapterProgress() throws {
        let loginViewModel = LoginViewModel()
        let chaptersViewModel = ChaptersViewModel()
        let expectation = self.expectation(description: "UserProgress")
        expectation.assertForOverFulfill = false
        
        var uploadStatus: UploadStatus?
        
        chaptersViewModel.chaptersArr.removeAll()
        chaptersViewModel.clearAllData()
        
        chaptersViewModel.downloadChapters { _ in
            chaptersViewModel.organizeChaptersByNumber {
                chaptersViewModel.retrieveUserbaseCompletion { _ in
                    loginViewModel.loginUser(email: "dummy@email.com", password: "Dummy123") { _ in
                        chaptersViewModel.startUserDownload(email: "dummy@email.com") { status in
                            switch status {
                            case .success:
                                chaptersViewModel.loggedInUser.classroom[0].chapterProgress[0].chapterStatus = "complete"
                                chaptersViewModel.saveUserProgressToCloud { statusTwo in
                                    uploadStatus = statusTwo
                                    expectation.fulfill()
                                }
                            case .failure:
                                print("Something went wrong...")
                            }
                            
                        }
                    }
                }
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(uploadStatus)
        XCTAssertEqual(uploadStatus, .success)
    }
}
