//  INFO49635 - CAPSTONE FALL 2022
//  ChatpterLesson.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation

struct ChapterLesson:Identifiable,Equatable, Hashable {
    let id = UUID()
    var content: [String]
    
    /// Getting ID
    func getID() -> UUID{
        return id
    }
    
    /// Getting content
    func getContent() -> [String]{
        return content
    }
    
    /// Setting content
    mutating func setContent(lessonContent: [String]) {
        content = lessonContent
    }
}


