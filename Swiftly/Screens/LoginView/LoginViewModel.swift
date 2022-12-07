//  INFO49635 - CAPSTONE FALL 2022
//  LoginViewModel.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

enum LoginStatus {
    case success
    case failure
}

final class LoginViewModel: ObservableObject {
    
    /// Published variables
    @Published var loggedInEmail : String = ""
    @Published var isShowingSignupView = false
    @Published var isSuccessful: Bool = false
    @Published var isBadLogin: Bool = false
    @Published var isLoggedOut: Bool = false
    @Published var accountMode:  String = "Student"
    @Published var accountTypeNotChosen: Bool =  false
    @Published var isLoading: Bool = false
    @Published var alertInfo: AlertModel?
    
    @Published var showLoginSpinner = false
    
    var attemptingLogin: Bool = false
    
    private var db = Firestore.firestore()
    
    func loginUser(email: String,
                   password: String,
                   completion: @escaping(LoginStatus) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] result, error in
            if error != nil {
                self.loginFailed(title: "Bad login", message: "Email and/or password are incorrect.")
                completion(.failure)
            } else {
                db.collection("Students").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                    if err != nil {
                        self.loginFailed(title: "Error", message: "Email exists in google auth but was not found in firestore.")
                        completion(.failure)
                    } else {
                        loginSuccess()
                        completion(.success)
                    }
                }
            }
        }
    }
    
    func loginFailed(title: String, message: String){
        alertInfo = AlertModel(id: .noAccountType, title: title, message: message)
        self.isSuccessful = false
        self.isBadLogin = true
        self.isLoading = false
    }
    
    func loginSuccess(){
        self.isSuccessful = true
        self.isBadLogin = false
        self.accountTypeNotChosen = false
    }
}
