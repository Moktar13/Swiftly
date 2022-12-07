//  INFO49635 - CAPSTONE FALL 2022
//  SwiftlyApp.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI
import UIKit
import Firebase
    
@main
struct SwiftlyApp: App {
    
    
    static var incomingChatbotMessages = [Message]()
    
    // Creating view models as environment objects
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var signupViewModel = SignupViewModel()
    @StateObject var chaptersViewModel = ChaptersViewModel()
    @StateObject var chapterContentViewModel = ChapterContentViewModel()
    @StateObject var userAccountViewModel = UserAccountViewModel()
    @StateObject var leaderboardViewModel = LeaderboardViewModel()
    @StateObject var chatbotViewModel = ChatbotViewModel()
    @StateObject var passwordRecoveryViewModel = PasswordRecoveryViewModel()
    
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            
            // Passing the environment objects down the hierarchy
            LoginView()
                .environmentObject(loginViewModel)
                .environmentObject(signupViewModel)
                .environmentObject(chaptersViewModel)
                .environmentObject(chapterContentViewModel)
                .environmentObject(userAccountViewModel)
                .environmentObject(leaderboardViewModel)
                .environmentObject(chatbotViewModel)
                .environmentObject(passwordRecoveryViewModel)
            
        }
    }
}
