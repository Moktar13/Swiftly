//  INFO49635 - CAPSTONE FALL 2022
//  Playground.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation

/// This represents the chapter playground section
struct Playground: Identifiable, Hashable {
    var id = UUID()
    var fId = ""
    var title: String
    var description: String
    var type: String
    var originalArr: [String]
    var mcqOptions = [""]
    var mcqAnswers = [""]
    
    /// Getting id
    func getID() -> UUID {
        return id
    }
    
    /// Getting firestore ID
    func getFID() -> String {
        return fId
    }
    
    /// Setting firestore ID
    mutating func setFID(id: String) {
        fId = id
    }
    
    /// Getting question
    func getQuestion() -> [String]{
        return originalArr
    }
    
    /// Setting question
    mutating func setQuestion(question: [String]){
        originalArr = question
    }
    
    /// Getting title
    func getTitle() -> String {
        return title
    }
    
    /// Setting title
    mutating func setTitle(qTitle: String){
        title = qTitle
    }
    
    /// Getting description
    func getDescription() -> String{
        return description
    }
    
    /// Setting description
    mutating func setDescription(desc: String){
        description = desc
    }
    
    /// Getting type
    func getType() -> String {
        return type
    }
    
    /// Setting type
    mutating func setType(qType: String){
        type = qType
    }
    
    /// Getting mcq options
    func getMcqOptions() -> [String]{
        return mcqOptions
    }
    
    /// Setting mcq options
    mutating func setMcqOptions(options: [String]) {
        mcqOptions = options
    }
    
    /// Getting mcq answers
    func getMcqAnswers() -> [String] {
        return mcqAnswers
    }
    
    /// Setting mcq answers
    mutating func setMcqAnswers(answers: [String]) {
        mcqAnswers = answers
    }
}
