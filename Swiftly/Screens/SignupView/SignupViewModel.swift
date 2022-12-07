//  INFO49635 - CAPSTONE FALL 2022
//  SignupViewModel.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

enum EmailStatus {
    case taken
    case free
    case unknown
}

enum SignupStatus {
    case success
    case failure
    case unknown
}

enum AlertType {
    case profanity
    case badSignup
}

final class SignupViewModel: ObservableObject {
    
    @Published var newUser = User(firstName: "",
                                  lastName: "",
                                  username: "",
                                  email: "",
                                  password: "",
                                  dob : "",
                                  country: "Canada",
                                  classroom: [UserClassroom()])
    
    @Published var result = ""
    
    @Published var isBadSignup: Bool = false
    @Published var alertInfo: AlertModel?
    @Published var chaptersArr = [Chapter]()
    @Published var loadingSignupProcess: Bool = false
    @Published var doesNameContainProfanity = false
    @Published var showAlert = false
    
    private var db = Firestore.firestore()
    
    //validation checks
    
    let listOfBadWords = ["crap", "fuck", "shit", "ass", "penis", "dick","cunt", "whore", "vagina", "boobs", "tits", "fucker", "slut", "motherfucker", "cock", "dildo", "bitch"]
    
    func isEmailValid() -> Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: newUser.email)
    }
    
    func isDateValid() -> Bool{
        let dateTest = NSPredicate(format: "SELF MATCHES %@", "^\\d{2}\\/\\d{2}\\/\\d{4}$")
        return dateTest.evaluate(with: newUser.dob)
    }
    
    
    func isPasswordValid() -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=[^\\d_].*?\\d)\\w(\\w|[!@#$%]){7,20}")
        return passwordTest.evaluate(with: newUser.password)
    }
    
    func isUserNameValid() -> Bool{
        let userNameTest = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z](_(?!(\\.|_))|\\.(?!(_|\\.))|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]$")
        return userNameTest.evaluate(with: newUser.username)
    }
    
    func isFirstNameValid() -> Bool{
        return newUser.firstName != ""
    }
    
    func isLastNameValid() -> Bool{
        return newUser.lastName != ""
    }
    
    func isCountryValid() -> Bool{
        return newUser.country != ""
    }
    
    func getAlertType() -> AlertType {
        
        if doesNameContainProfanity {
            return .profanity
        } else {
            return .badSignup
        }
        
    }
    
    // Boolean variable that determines if user credentials are valid, based on previous validation functions
    var isSignUpComplete : Bool {
        if !isEmailValid(){
            return false
        }
        
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
    
    func validateName(name: String) -> Bool {
        return listOfBadWords.reduce(false) { $0 || name.lowercased().contains($1.lowercased()) }
    }
    
    // Function to check if email already exists in Swiftly database
    func checkIfEmailExists(user: User, completion: @escaping(EmailStatus) -> Void){
        print("Email check started!")
        let emailCompared = user.email
        let collectionRef = db.collection("Students")
        var userCounter = 0
        
        print("Now going through database to compare email")
        collectionRef.whereField("email", isEqualTo: emailCompared).getDocuments { (snapshot, err) in
            if err != nil {
                print("email is unknown")
                completion(.unknown)
            } else if (snapshot?.isEmpty)! {
                print("email is free")
                self.result = "free"
                completion(.free)
            } else {
                
                for document in (snapshot?.documents)! {
                    
                    if document.data()["username"] != nil {
                        print("email is taken")
                        self.result = "taken"
                        completion(.taken)
                    }
                    
                    userCounter += 1
                    
                    if userCounter == snapshot?.documents.count {
                        print("email is free")
                        self.result = "free"
                        completion(.free)
                    }
                }
            }
        }
    }
    
    func testCheckOverlappingEmail(completion: @escaping() -> Void){
        print("Email check started!")
        let emailCompared = newUser.email
        let collectionRef = db.collection("Students")
        var userCounter = 0
        
        print("Now going through database to compare email")
        collectionRef.whereField("email", isEqualTo: emailCompared).getDocuments { (snapshot, err) in
            if err != nil {
                print("email is unknown")
                self.result = "unknown"
            } else if (snapshot?.isEmpty)! {
                print("email is free")
                self.result = "free"
            } else {
                
                for document in (snapshot?.documents)! {
                    
                    if document.data()["username"] != nil {
                        print("email is taken")
                        self.result = "taken"
                        break
                    }
                    
                    userCounter += 1
                    
                    if userCounter == snapshot?.documents.count {
                        print("email is free")
                        self.result = "free"
                    }
                }
            }
            completion()
        }
    }
    
    // Authenticating the user
    func authenticateUser(user: User, completion: @escaping(Bool) -> Void){
        Auth.auth().createUser(withEmail: user.email, password: user.password) { [self] user, error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func addUser(user: User, completion: @escaping(SignupStatus) -> Void){
        
        var newStudent = db.collection("Students").document(user.username)
        
        newStudent.setData([
            "country": user.country,
            "date_of_birth": user.dob,
            "email": user.email,
            "firstname" : user.firstName,
            "username" : user.username,
            "lastName" : user.lastName,
            //"password" : user.password
        ]) { err in
            if err != nil {
                completion(.failure)
            }
        }
        
        newStudent = newStudent.collection("Classrooms").document("classroom_1")
        newStudent.setData(["instructor_id" : "placeholder"])
        
        // Creating collection for user classrooms, which will contain users progress, answers and scores for each chapter
        for i in 0..<chaptersArr.count{

            if (chaptersArr[i].chapterNum > 0){
                
                newStudent.collection("Chapters").document(chaptersArr[i].firestoreID).setData([
                    "chapters_num" : chaptersArr[i].chapterNum,
                    "chapters_name" : chaptersArr[i].name,
                    "playground_status" : "incomplete",
                    "chapter_status" : "incomplete",
                    "theory_status" : "incomplete",
                    "total_question_score": 0,
                    "chapter_id": chaptersArr[i].firestoreID])
                
                var playgroundQuestionScores: [Int] = []
                let playgroundAnswers: [String] = []
                var playgroundProgress: [String] = []
                var questionsId: [String] = []
                
                let document = newStudent.collection("Chapters").document(chaptersArr[i].firestoreID)
                
                for j in 0..<chaptersArr[i].playgroundArr.count {
                    questionsId.append(chaptersArr[i].playgroundArr[j].fId)
                    playgroundQuestionScores.append(0)
                    playgroundProgress.append("incomplete")
                    document.updateData(["question_\(j+1)_answer" : playgroundAnswers])
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    document.updateData(["question_scores": playgroundQuestionScores,
                                         "question_progress": playgroundProgress,
                                         "question_ids": questionsId,
                                         "total_questions": self.chaptersArr[i].playgroundArr.count])
                }
            }
            
            if i+1 == chaptersArr.count {
                completion(.success)
            }
        }
    }
    
    func saveNewUser(completion: @escaping(SignupStatus) -> Void){
        
        checkIfEmailExists(user: newUser) { status in
            switch status {
            case .taken:
                self.isBadSignup = true
                completion(.failure)
            case .free:
                
                self.authenticateUser(user: self.newUser) { authenticated in
                    
                    if authenticated {
                        
                        self.addUser(user: self.newUser) { signupStatus in
                            switch signupStatus {
                            case .success:
                                self.result = "success"
                                completion(.success)
                            case .failure:
                                self.result = "failure"
                                completion(.failure)
                            case .unknown:
                                self.result = "unknown"
                                completion(.unknown)
                            }
                        }
                    } else {
                        self.result = "failure"
                        completion(.failure)
                    }
                }
                
            case .unknown:
                self.result = "unknown"
                completion(.unknown)
            }
        }
    }
}
