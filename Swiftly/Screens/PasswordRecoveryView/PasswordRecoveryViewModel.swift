//  INFO49635 - CAPSTONE FALL 2022
//  PasswordRecoveryViewModel.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore


final class PasswordRecoveryViewModel: ObservableObject {
    
    init(){
        //initializer
    }
    
    
    //published variables
    @Published var toggleNow: Bool = false
    @Published var email: String = ""
    
    //boolean to ensure the email being used to reset password exists
    @Published var emailExists: Bool = false
    @Published var result = ""
    @Published var alertInfo: AlertModel?
    //db variable for firestore information
    private var db = Firestore.firestore()
    
    
    
    func isEmailValid() -> Bool{
        
        ///email input must be in email@email.com format
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    func testEmailCheck(completion: @escaping() -> Void){
        print("Email check started!")
        let emailCompared = email
        let collectionRef = db.collection("Students")
        var userCounter = 0
        
        print("Now going through database to compare email")
        collectionRef.whereField("email", isEqualTo: emailCompared).getDocuments { (snapshot, err) in
            if err != nil {
                print("email is unknown")
                self.result = "unknown"
            } else if (snapshot?.isEmpty)! {
                print("email is free")
                self.emailExists = false
            } else {
                
                for document in (snapshot?.documents)! {
                    
                    if document.data()["username"] != nil {
                        print("email is taken")
                        self.emailExists = true
                        break
                    }
                    
                    userCounter += 1
                    
                    if userCounter == snapshot?.documents.count {
                        print("email is free")
                        self.emailExists = false
                    }
                }
            }
            completion()
        }
    }
    
    func checkIfEmailExists(emailChecked: String, completion: @escaping() -> Void){
        print("Email to be checked if it exists in Users collection is : \(emailChecked)")
        
        let emailCompared = emailChecked
        
        /// retrieving  Firebase collection
        let collectionRef = db.collection("Students")
        
        /// getting all the documents where the field username is equal to the String you pass, loop over all the documents.
        
        collectionRef.whereField("email", isEqualTo: emailCompared).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                print("Email does NOT exist.")
                self.emailExists = false
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["username"] != nil {
                        print("Email DOES exist.")
                        self.emailExists = true
                        
                    }
                }
            }
            completion()
        }
        
    }
    
    func resetPassword(completion: @escaping() -> Void){
        
        //checks if email is in database
        checkIfEmailExists(emailChecked: email){
            
        }
        
        //uses auth package to send recovery email to user
        Auth.auth().sendPasswordReset(withEmail: email){ error in
            if(!self.emailExists){
                print("Email does not exist, not sending reset")
                self.alertInfo = AlertModel(id: .emailNotFoundInCollection, title: "Email Not Found", message: "Please enter valid email.")
                self.result = "Failure"
                return
            }
            else{
                print("Email sent successfully")
                self.alertInfo = AlertModel(id: .emailNotFoundInCollection, title: "Email Successfully Sent", message: "Please check email to reset password.")
                self.result = "Success"
            }
            completion()
        }
    }
}
    
