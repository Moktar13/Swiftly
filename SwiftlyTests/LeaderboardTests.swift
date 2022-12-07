//  INFO49635 - CAPSTONE FALL 2022
//  LeaderboardTests.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import XCTest
@testable import Swiftly
@testable import Pods_Swiftly

class LeaderboardTests: XCTestCase {
    
    func testRetrieveUserScores() throws {
        let leaderboardViewModel = LeaderboardViewModel()
        let expectation = self.expectation(description: "Download")
        
        var scoreData: [UserLeaderboardData]?
        
        leaderboardViewModel.retrieveBasicUserData(filterOne: nil,
                                                   filterTwo: leaderboardViewModel.getCountryStringFromFlag(country: "None"),
                                                   completion: { status, data in
            scoreData = data
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(scoreData)
        XCTAssertEqual(scoreData?.isEmpty, false)
    }
    
    
    func testRetrieveUserScoresWithFilters() throws {
        let leaderboardViewModel = LeaderboardViewModel()
        let expectation = self.expectation(description: "Download")
        
        var scoreData: [UserLeaderboardData]?
        
        leaderboardViewModel.retrieveBasicUserData(filterOne: "Chapter 1",
                                                   filterTwo: leaderboardViewModel.getCountryStringFromFlag(country: "🇨🇦"),
                                                   completion: { status, data in
            scoreData = data
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(scoreData)
        XCTAssertEqual(scoreData?.isEmpty, false)
    }
}
