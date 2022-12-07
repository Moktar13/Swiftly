//  INFO49635 - CAPSTONE FALL 2022
//  InteractiveView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct InteractiveView: View {
    
    /// View responsive variables
    @State var willUpdateView = false
    @State private var dragging: InteractiveBlock?
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    
    /// Init for view
    init() {
        UITableView.appearance().separatorColor = UIColor(Color.clear)
        UITableView.appearance().isScrollEnabled = false
        UITableView.appearance().backgroundColor = .clear
    }
    
    /// View
    var body: some View {
        
        GeometryReader { geometry in
            ZStack{
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack{
                    HStack {
                        Button{
                            chapterContentViewModel.willStartPlaygroundQuestion.toggle()
                        }label:{
                            NavBarIcon(iconName: "xmark")
                                .accessibilityLabel("Close Button")
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                        

                    }
                    .padding(.top, geometry.size.width/16)
                    .padding(.bottom, geometry.size.width/32)
                    
                    HStack{
                        Spacer()
                        InteractiveSubTitle(text: chapterContentViewModel.selectedQuestion.title)
                            .accessibilityLabel(chapterContentViewModel.selectedQuestion.title)
                        Spacer()
                    }
                    
                    /// For actual interactive section
                    VStack{
                        Group {
                            /// For code blocks method
                            if (chapterContentViewModel.selectedQuestion.type == "code_blocks"){
                                
                                ScrollView {
                                    
                                    LazyVGrid(columns: chapterContentViewModel.columns, spacing: 20) {
                                        ForEach(chapterContentViewModel.activeBlocks) { block in
                                            
                                            /// Creating the tile view and passing the code block struct to it
                                            InteractiveTileView(codeBlock: block)
                                                .overlay(dragging?.id == block.id ? Color.clear : Color.clear)
                                                .cornerRadius(20)
                                                .onDrag {
                                                    self.dragging = block
                                                    return NSItemProvider(object: String(block.id) as NSString)
                                                }
                                                .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: block, listData: $chapterContentViewModel.activeBlocks, current: $dragging))
                                                .accessibilityLabel(block.content)
                                        }
                                        Spacer()
                                    }
                                    .animation(.default, value: chapterContentViewModel.activeBlocks)
                                    .padding(.top, geometry.size.height/16)
                                }
                                .onDrop(of: [UTType.text], delegate: DropOutsideDelegate(current: $dragging))
                                .hasScrollEnabled(false)
                                
                                /// For mcq method
                            }else{
                                
                                
                                ForEach(chapterContentViewModel.mcqOptions, id: \.self) { item in
                                    MultipleSelectionRow(title: item, isSelected: chapterContentViewModel.mcqUserAnswers.contains(item)) {
                                        
                                        if chapterContentViewModel.mcqUserAnswers.contains(item) {
                                            chapterContentViewModel.mcqUserAnswers.removeAll(where: { $0 == item })
                                        }
                                        else {
                                            chapterContentViewModel.mcqUserAnswers.append(item)
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    .accessibilityLabel(item)
                                }
                                .frame(width: UIScreen.screenWidth/1.25, height: 100, alignment: .leading)
                                .padding(.top, 10)
                                
                                Spacer()
                            }
                        }
                    }.frame(width: geometry.size.width/1.0, height: geometry.size.height/1.50, alignment: .center)
                    
                    ZStack{
                        Color.blueCustom
                            .ignoresSafeArea()
                        HStack{
                            InteractiveContentText(text: chapterContentViewModel.selectedQuestion.description)
                                .padding(.leading, 15)
                                .padding(.bottom, 20)
                                .padding(.top, -10)
                                .minimumScaleFactor(0.5)
                                .accessibilityLabel(chapterContentViewModel.selectedQuestion.description)
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                
                                /// Next question button
                                Button{
                                    
                                    /// Chapter index
                                    let chapIndex = chaptersViewModel.selectedChapterIndex
                                    
                                    /// Getting the question index
                                    let index = chapterContentViewModel.selectedQuestionIndex
                                    
                                    /// Saving chapter score
                                    chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionProgress[index] = "complete"
                                    
                                    /// If question type is code blocks, loop through the code blocks and
                                    /// save each of their contents to the users
                                    if (chapterContentViewModel.selectedQuestion.type == "code_blocks"){
                                        
                                        chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index].answers.removeAll()
                                        
                                        let answersArr = chaptersViewModel.chaptersArr[chapIndex].playgroundArr[index].originalArr
                                        
                                        for i in 0..<chapterContentViewModel.activeBlocks.count {
                                            
                                            let answer = chapterContentViewModel.activeBlocks[i].content
                                            
                                            let answerIndex = answersArr.firstIndex(of: answer)
                                            
                                            chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index].answers.append(String(answerIndex!))
                                        }
                                         
                                    } else{
                                        
                                        chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index].answers.removeAll()
                                        
                                        for k in 0..<chapterContentViewModel.mcqUserAnswers.count {
                                            let answer = chapterContentViewModel.mcqUserAnswers[k]
                                            let answerIndex = chapterContentViewModel.mcqOptions.firstIndex(of: answer)
                                            
                                            
                                          
                                            chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index].answers.append(String(answerIndex!))
                                        }

//                                        chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index].answers = chapterContentViewModel.mcqUserAnswers
                                    }
                                    
                                    /// Getting the user score
                                    let score = chapterContentViewModel.getQuestionScore()
                                    
                                    /// Saving the score, and setting status to complete
                                    chapterContentViewModel.playgroundQuestionScores[index] = score
                                    chapterContentViewModel.playgroundQuestionStatus[index] = "complete"
                                    
                                    chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chaptersViewModel.selectedChapterIndex].questionScores[index] = score
                                    
                                    
                                    // Adding a point
                                    if chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].chapterScore < chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].totalQuestions &&
                                        chapterContentViewModel.didUserCompleteQuestion() == true {
                                        chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].chapterScore += 1
                                    }
                                    
                                    
                                    /// If it's the last question
                                    if (index == chapterContentViewModel.playgroundQuestionScores.count-1){

                                        /// Setting playground progress to complete
                                        chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].playgroundStatus = "complete"
                                        
                                        chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].theoryStatus = "complete"
                                        
                                        chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].chapterStatus = "complete"
                                        
                                        chaptersViewModel.chaptersStatus[chapIndex] = "complete"
                                        
                                        /// If it's the last chapter in the classroom
                                        if (chapIndex == chaptersViewModel.loggedInUser.classroom[0].classroomPlaygroundStatus.count-1){
                                            
                                            chaptersViewModel.loggedInUser.classroom[0].classroomPlaygroundStatus = "complete"
                                            chaptersViewModel.loggedInUser.classroom[0].classroomStatus = "complete"
                                        }
                                    }
                                    
                                    chaptersViewModel.saveUserProgressToCloud { status in
                                        print(status)
                                    }
                                    
                                    chaptersViewModel.retrieveUserbaseCompletion(completion: { _ in })
                                    
                                    
                                }label: {
                                    InteractiveSubTitle(text: chapterContentViewModel.chapterButtonText)
                                        .accessibilityLabel(chapterContentViewModel.chapterButtonText)
                                }
                                .frame(width: geometry.size.width/5, height: geometry.size.width/10)
                                .background(Color.blackCustom)
                                .cornerRadius(15)
                                .padding(.bottom, 20)
                                .padding(.trailing, 15)
                                .padding(.top, -10)
                            }.frame(width: geometry.size.width/4, alignment: .center)
                        }
                    }.frame(width: geometry.size.width, height: geometry.size.height/5)
                }
                .alert(isPresented: $chapterContentViewModel.isShowingScore){
                    Alert(
                        title: Text("Your Score"),
                        message: Text("You scored: \(chapterContentViewModel.userScore)/\(chapterContentViewModel.totalScore)"),
                        
                        dismissButton: .default(Text("OK"), action: {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
                                /// Used to either proceed to next question, or finish interactive section
                                if (chapterContentViewModel.isFinalChapter == false){
                                    
                                    let index = chapterContentViewModel.selectedQuestionIndex + 1
                                    
                                    chapterContentViewModel.startNextPlaygroundQuestion(userAnswers: chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chaptersViewModel.selectedChapterIndex].questionAnswers[index].answers)
                                    
                                    willUpdateView.toggle()
                                }else{
                                    chapterContentViewModel.completeInteractiveSection()
                                }
                            }
                        })
                    )
                }
                .accessibilityLabel("You Score: \(chapterContentViewModel.userScore)/\(chapterContentViewModel.totalScore)")
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            
            chapterContentViewModel.mcqUserAnswers.removeAll()
            chapterContentViewModel.activeBlocks.removeAll()
            
            chapterContentViewModel.willStartNextQuestion = false
            chapterContentViewModel.isShowingScore = false
        }
        
        .onAppear(){
            
        }
        
        /// For clearing user input when they exit
//        .onAppear(){
//            chapterContentViewModel.mcqUserAnswers.removeAll()
//
//            for i in 0..<chapterContentViewModel.selectedQuestion.originalArr.count {
//                chapterContentViewModel.activeBlocks[i] = InteractiveBlock(id: i, content: chapterContentViewModel.selectedQuestion.originalArr[i])
//            }
//        }
    }
}

/// Preview
struct InteractiveView_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveView()
    }
}
