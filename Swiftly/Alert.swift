//  INFO49635 - CAPSTONE FALL 2022
//  Alert.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct AlertModel: Identifiable {
    enum AlertType {
        case badLogin
        case noAccountType
        case emailNotFoundInCollection  // this will never happen
    }
    
    let id: AlertType
    let title: String
    let message: String
}

