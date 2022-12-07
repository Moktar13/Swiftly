//  INFO49635 - CAPSTONE FALL 2022
//  UserAccountViewModel.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI
import Firebase

final class UserAccountViewModel: ObservableObject {

    @Published var logoutSuccessful = false
    
    @Published var isEditingAccount = false
    
    @Published var chapterCompletionProgress: Float = 0.0
    @Published var chapterInProgressProgress: Float = 0.0
    @Published var questionCompletedProgress: Float = 0.0
    
    private var db = Firestore.firestore()
    
    @Published var loggedInUser = User(firstName: "",
                       lastName: "",
                       username: "",
                       email: "",
                       password: "",
                       dob : "",
                       country: "",
                       classroom: [UserClassroom()])
    
    
    @Published var result = ""
    
    @Published var classroomName = ""
    
    @Published var isUserInfoRetrieved = false
    
    @Published var showAlert = false
    @Published var doesNameContainProfanity = false
    @Published var isBadSignup: Bool = false
    
    @Published var userChapterCompletionCount = 0
    @Published var userChapterInProgressCount = 0
    
//    @Published var userTotalScore = 0
//    @Published var userTotalPossibleScore = 0
//    @Published var userQuestionCompleteCount = 0
    
    var loggedInAccountType : String = ""
    
    let listOfBadWords = ["crap", "fuck", "shit", "ass", "penis", "dick","cunt", "whore", "vagina", "boobs", "tits", "fucker", "slut", "motherfucker", "cock", "dildo", "bitch"]
    
    
    @Published var updatedUser = User(firstName: "",
                       lastName: "",
                       username: "",
                       email: "",
                       password: "",
                       dob : "",
                       country: "",
                       classroom: [UserClassroom()]
                    )
    
    func getAlertType() -> AlertType {
        
        if doesNameContainProfanity {
            return .profanity
        } else {
            return .badSignup
        }
        
    }
    
    func validateName(name: String) -> Bool {
        return listOfBadWords.reduce(false) { $0 || name.lowercased().contains($1.lowercased()) }
    }
    
    
    //validation methods for updating account
    
    func isDateValid() -> Bool{
        
        //must be in dd/mm/yyyy format, only numerics
        
        let dateTest = NSPredicate(format: "SELF MATCHES %@", "^\\d{2}\\/\\d{2}\\/\\d{4}$")
        return dateTest.evaluate(with: updatedUser.dob)
    }
    
    
    func isPasswordValid() -> Bool{
        
        //Password must be at least 8 characters, no more than 15 characters, and must include at least one upper case letter, one lower case letter, and one numeric digit.
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=[^\\d_].*?\\d)\\w(\\w|[!@#$%]){7,20}")
        return passwordTest.evaluate(with: updatedUser.password)
    }
    
    func isUserNameValid() -> Bool{
        return updatedUser.username != ""
    }
    
    func isFirstNameValid() -> Bool{
        return updatedUser.firstName != ""
    }
    
    func isLastNameValid() -> Bool{
        return updatedUser.lastName != ""
    }
    
    func isCountryValid() -> Bool{
        return updatedUser.country != ""
    }
    
    
    var isEditingComplete : Bool {
        
        if !isPasswordValid(){
            return false
        }
        
        if !isDateValid(){
            return false
        }
        if !isUserNameValid(){
            return false
        }
        if !isFirstNameValid(){
            return false
        }
        if !isLastNameValid(){
            return false
        }
        if !isCountryValid(){
            return false
        }
        return true
    }
    
    
    //function for passing currently logged in users info into another User variable to be used for updating account info
    
    func retrieveAccountinfo(){
        updatedUser.firstName = loggedInUser.firstName
        updatedUser.lastName = loggedInUser.lastName
        updatedUser.username = loggedInUser.username
        updatedUser.email = loggedInUser.email
        //updatedUser.password = loggedInUser.password
        updatedUser.dob = loggedInUser.dob
        updatedUser.country = loggedInUser.country
    }
    
    func clearStats(){
        userChapterCompletionCount = 0
        userChapterInProgressCount = 0
//        userTotalScore = 0
//        userQuestionCompleteCount = 0
        chapterCompletionProgress = 0
        chapterInProgressProgress = 0
        questionCompletedProgress = 0
    }
    
    func getUserStats(){
        
        print("getUserStats")
        
        let totalChapters = loggedInUser.classroom[0].chapterProgress.count
        var completeChapters = 0
        var inprogessChapters = 0
        
        var totalQuestions = 0
        var completeQuestions = 0
        
        
        
        for i in 0..<totalChapters{
            
            print("Chaper: \(i+1)")
            
            if (loggedInUser.classroom[0].chapterProgress[i].chapterStatus == "complete"){
                completeChapters += 1
            }
            
            else if (loggedInUser.classroom[0].chapterProgress[i].chapterStatus == "inprogress"){
                inprogessChapters += 1
            }
            
            
            for k in 0..<loggedInUser.classroom[0].chapterProgress[i].questionScores.count{
//                userTotalScore += loggedInUser.classroom[0].chapterProgress[i].questionScores[k]
                
                totalQuestions += 1
                if (loggedInUser.classroom[0].chapterProgress[i].questionProgress[k] == "complete"){
                    completeQuestions += 1
                }
            }
        }
        
        chapterCompletionProgress = Float(completeChapters) / Float(totalChapters)
        chapterInProgressProgress = Float(inprogessChapters) / Float(totalChapters)
        questionCompletedProgress = Float(completeQuestions) / Float(totalQuestions)
       
        
    }
    
    func updateAccount(completion: @escaping() -> Void){
        
        print("Logged In: \(loggedInUser)")
        print("Updated: \(updatedUser)")
        
        //first update the firebase authentication with new information (password specifically)
        
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: loggedInUser.email, password: loggedInUser.password)

        
        print("Now attempting to reauthenticate the authentication data")
        user?.reauthenticate(with: credential, completion: {(authResult, error) in
                    if error != nil {
                        print("Error: \(String(describing: error))")
                        completion()
                    }else{
                        print("Successfully Reauthenticated! ")
                    }
                })
        
        Auth.auth().currentUser?.updatePassword(to: updatedUser.password) { (error) in
          print("Successfully updated password!")
        }
        
        print("Now updating firestore database data")
        let updatingRef = db.collection("Students").document(loggedInUser.username)

        updatingRef.updateData([
            "country": updatedUser.country,
            "date_of_birth": updatedUser.dob,
            "firstname" : updatedUser.firstName,
            "lastName" : updatedUser.lastName,
            //"password" : updatedUser.password,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.result = "success"
                self.loggedInUser.firstName = self.updatedUser.firstName
                self.loggedInUser.lastName = self.updatedUser.lastName
                self.loggedInUser.username = self.updatedUser.username
                self.loggedInUser.email = self.updatedUser.email
                //self.loggedInUser.password = self.updatedUser.password
                self.loggedInUser.dob = self.updatedUser.dob
                self.loggedInUser.country = self.updatedUser.country
            }
            completion()
        }
    }
    

    /// Function to logout the user
    func logoutUser(){
        do {
            try Auth.auth().signOut()
            self.isUserInfoRetrieved = false
            logoutSuccessful = true
            loggedInAccountType = ""
            loggedInUser = User(firstName: "",
                                lastName: "",
                                username: "",
                                email: "",
                                password: "",
                                dob : "",
                                country: "",
                                classroom: [UserClassroom()]
                             )

            updatedUser = User(firstName: "",
                                lastName: "",
                                username: "",
                                email: "",
                                password: "",
                                dob : "",
                                country: "",
                                classroom: [UserClassroom()]
                                )
            
            self.clearStats()
            
        }
        catch {
            print("already logged out")
            logoutSuccessful = false
        }
    }
}
