//  INFO49635 - CAPSTONE FALL 2022
//  ChapterContentViewModel.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI


final class ChapterContentViewModel: ObservableObject {
    
    
    /// Representing the current chapter and it's playground questions
    var chapter: Chapter
    var chapterPlaygroundQuestions: [Playground]
    var selectedQuestion: Playground
    
    var isFirstLesson = true
    
    var userScore = 0
    var totalScore = 0
    
    var playgroundQuestionScores = [Int]()
    var playgroundQuestionStatus = [String]()
    var selectedQuestionIndex = 0
    
    let columns = [GridItem(.flexible())]
    
    /// This is used to allow interaction with blocks
    @Published var activeBlocks: [InteractiveBlock]
    @Published var willQuitChapter = false
    @Published var willStartInteractiveSection = false
    @Published var willStartPlaygroundQuestion = false
    @Published var chapterButtonText = "Next"
    @Published var isFinalChapter = false
    @Published var willStartNextQuestion = false
    @Published var mcqOptions: [String] = []
    @Published var mcqUserAnswers: [String] = []
    @Published var isShowingScore = false
    @Published var isShowingChabot = false
    
    var customOpacity = 1.0
    var buttonEnable = false
    
    
    /// Init variables with basic data
    init(){
        chapter = MockData.sampleChapter
        chapterPlaygroundQuestions = chapter.playgroundArr
        selectedQuestion = chapterPlaygroundQuestions[0]
        selectedQuestionIndex = 0
        activeBlocks = Array(repeating: InteractiveBlock(id: 0, content: ""), count: 1)
    }
    
    /// Function which modifies the button text in the view
    func checkQuestionInfo(){
        
        /// If the question is the last one, otherwise ...
        if (selectedQuestionIndex == chapterPlaygroundQuestions.count-1){
            chapterButtonText = "Submit"
            isFinalChapter = true
        }else{
            chapterButtonText = "Next"
            isFinalChapter = false
        }
    }
    
    /// Called to setup the playground environment (all questions)
    func setupPlaygroundQuestions(selectedChapter: Chapter){
        
        /// Grabs chapter and chapter playground questions
        chapter = selectedChapter
        chapterPlaygroundQuestions = chapter.playgroundArr
        
        playgroundQuestionStatus.removeAll()
        playgroundQuestionScores.removeAll()
        
        /// Setting up playground question status arr --> used to keep track of individual question progress
        for i in 0..<chapterPlaygroundQuestions.count{
            playgroundQuestionStatus.append("incomplete")
            playgroundQuestionScores.append(0)
        }
    }
    
    /// Called to start the next playground question
    func startNextPlaygroundQuestion(userAnswers: [String]){
        
        /// Incrementing to next chapter
        selectedQuestionIndex += 1
        selectedQuestion = chapterPlaygroundQuestions[selectedQuestionIndex]
        
        /// Setting up the next playground
        setupPlayground(question: selectedQuestion, questionIndex: selectedQuestionIndex, userAnswers: userAnswers)
        
        willStartNextQuestion = true
    }
    
    
    /// Called from InteractiveQuestionsView
    func setupPlayground(question: Playground, questionIndex: Int, userAnswers: [String]){
        
        selectedQuestion = question
        selectedQuestionIndex = questionIndex
        
        if (selectedQuestion.type == "code_blocks"){
            
            var codeBlocks: [String] = []
            
            /// If the user's answers is empty (first time doing question) then use default values
            if (userAnswers.isEmpty){
                codeBlocks = selectedQuestion.originalArr
                
                while (codeBlocks == selectedQuestion.originalArr) {
                    codeBlocks.shuffle()
                }
                
            }else{
                
                for k in 0..<userAnswers.count{
                    let answerIndex = userAnswers[k]
                    let index = Int(answerIndex)
                    codeBlocks.append(selectedQuestion.originalArr[index!])
                }
            }
            
            /// Pre-populates array with interactive block objects
            activeBlocks = Array(repeating: InteractiveBlock(id: 0, content: ""), count: codeBlocks.count)
            
            /// Copying content from playground blocks to array active blocks --> active blocks is the array that is copied and
            /// the user interacts with it. It gets compared to the original array to get user score.
            for i in 0..<codeBlocks.count {
                activeBlocks[i] = InteractiveBlock(id: i, content: codeBlocks[i])
            }
            
            
        }else if (selectedQuestion.type == "mcq"){
            
            mcqOptions = selectedQuestion.originalArr
            
            
            if (userAnswers.isEmpty == false){
                
                for k in 0..<userAnswers.count{
                    let answerIndex = userAnswers[k]
                    let index = Int(answerIndex)
                    mcqUserAnswers.append(selectedQuestion.originalArr[index!])
                }
                
                
//                mcqUserAnswers = userAnswers
            }else{
                mcqUserAnswers = []
            }
        }
        
        /// This will make navigation go
        willStartPlaygroundQuestion = true
        
        /// Checking question info
        checkQuestionInfo()
    }
    
    /// Quits the current chapter
    func quitChapter(){
        willQuitChapter = true
    }
    
    /// Starts interactive section of chapter
    func startInteractiveSection(){
        willStartInteractiveSection = true
    }
    
    func didUserCompleteQuestion() -> Bool {
        userScore = getQuestionScore()
        
        totalScore = 0
        
        switch selectedQuestion.type {
        case "code_blocks":
            totalScore = selectedQuestion.originalArr.count
        case "mcq":
            totalScore = selectedQuestion.mcqAnswers.count
        default:
            totalScore = 0
        }
        
        if userScore == totalScore {
            return true
        }
        
        return false
    }
    
    /// Used to retrieve the score of the user
    func getQuestionScore() -> Int {
        
        userScore = 0
        
        
        
        /// Checking code block answer
        if (selectedQuestion.type == "code_blocks"){
            
            totalScore = selectedQuestion.originalArr.count
            
            for i in 0..<selectedQuestion.originalArr.count {
                if (activeBlocks[i].content == selectedQuestion.originalArr[i]){
                    userScore += 1
                }
            }
            
        }else{
            if (mcqUserAnswers.isEmpty == false){
                
                totalScore = selectedQuestion.mcqAnswers.count
                
                for i in 0..<mcqUserAnswers.count {
                    
                    let answer = mcqUserAnswers[i]
                    
                    if (selectedQuestion.mcqAnswers.contains(answer)){
                        userScore += 1
                    }else{
                        userScore -= 1
                    }
                }
                
                if (userScore < 0){
                    userScore = 0
                }
            }
        }
        
        self.isShowingScore = true
        
        return userScore
    }
    
    /// Finishes the playground section and returns to the playground questions view
    func completeInteractiveSection(){
        willStartPlaygroundQuestion = false
    }
    
    /// Retrieves the base64 of a string
    func getBase64(original: String) -> String{
        
        var imgBase64: String = ""
        let imgString = original
        
        /// For PNG
        if (imgString.starts(with: "data:image/png")){
            imgBase64 = String(imgString.dropFirst(22))
        }
        
        /// For JPEG
        else if (imgString.starts(with: "data:image/jpeg")){
            imgBase64 = String(imgString.dropFirst(23))
        }
        
        return imgBase64
        
    }
    
    
    func setQuestionAvailability(question: Playground, chaptersViewModel: ChaptersViewModel){
        
    }
}
