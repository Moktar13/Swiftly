//  INFO49635 - CAPSTONE FALL 2022
//  InteractiveBlock.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI


/// Represents an interactive block that are contained within playground
struct InteractiveBlock: Identifiable, Equatable, Hashable {
    let id: Int
    let content: String
}
