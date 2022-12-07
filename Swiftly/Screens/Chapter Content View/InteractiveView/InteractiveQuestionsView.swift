//  INFO49635 - CAPSTONE FALL 2022
//  InteractiveQuestionsView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI
import GoogleMobileAds

struct InteractiveQuestionsView: View {
    
    /// View responsive variables
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    
    
    
    var customOpacity = 1.0
    var buttonEnable = false
    
    
    private var fullScreenAd: Interstitial?
    
    init() {
        fullScreenAd = Interstitial()
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
                            chapterContentViewModel.willStartInteractiveSection = false
                        }label:{
                            NavBarIcon(iconName: "chevron.backward")
                                .accessibilityLabel("Back Button")
                        }
                        .padding(.leading, 30)
                        Spacer()
                    }
                    .padding(.top, geometry.size.width/16)
                    
                    TitleLabel(text: "Chapter Questions")
                        .padding(.bottom, 50)
                        .accessibilityLabel("Chapter Questions")
                    
                    ScrollView{
                        
                        ForEach(chaptersViewModel.selectedChapter!.playgroundArr) { question in
                            
                            HStack{
                                
                                /// Question title
                                VStack(alignment: .leading){
                                    InteractiveSubTitlePreview(text: question.title)
                                        .minimumScaleFactor(0.5)
                                        .padding(.leading, 5)
                                        .padding(.trailing, 5)
                                        .accessibilityLabel(question.title)
                                    
                                    /// Grabbing question type
                                    Group{
                                        if question.type == "code_blocks"{
                                            InteractiveContentTextPreview(text: "Type: Code Tiles")
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                                .accessibilityLabel("Type: Code Tiles")
                                            
                                            let questionLength = question.originalArr.count
                                            
                                            if (questionLength <= 2){
                                                InteractiveContentTextPreview(text: "Difficulty: Easy")
                                                    .padding(.leading, 5)
                                                    .padding(.trailing, 5)
                                                    .padding(.bottom, 5)
                                                    .accessibilityLabel("Difficulty: Easy")
                                            } else if (questionLength <= 4){
                                                InteractiveContentTextPreview(text: "Difficulty: Medium")
                                                    .padding(.leading, 5)
                                                    .padding(.trailing, 5)
                                                    .padding(.bottom, 5)
                                                    .accessibilityLabel("Difficulty: Medium")
                                            } else if (questionLength >= 5){
                                                InteractiveContentTextPreview(text: "Difficulty: Hard")
                                                    .padding(.leading, 5)
                                                    .padding(.trailing, 5)
                                                    .padding(.bottom, 5)
                                                    .accessibilityLabel("Difficulty: Hard")
                                            }
                                        } else{
                                            InteractiveContentTextPreview(text: "Type: Multiple Choice Question")
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                                .accessibilityLabel("Type: Multiple Choice Question")
                                            
                                            let questionLength = question.originalArr.count
                                            
                                            if (questionLength <= 3){
                                                InteractiveContentTextPreview(text: "Difficulty: Easy")
                                                    .padding(.leading, 5)
                                                    .padding(.trailing, 5)
                                                    .padding(.bottom, 5)
                                                    .accessibilityLabel("Difficulty: Easy")
                                            }
                                            else if (questionLength <= 4){
                                                InteractiveContentTextPreview(text: "Difficulty: Medium")
                                                    .padding(.leading, 5)
                                                    .padding(.trailing, 5)
                                                    .padding(.bottom, 5)
                                                    .accessibilityLabel("Difficulty: Medium")
                                            }else if (questionLength >= 5){
                                                InteractiveContentTextPreview(text: "Difficulty: Hard")
                                                    .padding(.leading, 5)
                                                    .padding(.trailing, 5)
                                                    .padding(.bottom, 5)
                                                    .accessibilityLabel("Difficulty: Hard")
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                Group{
                                    
                                    /// Chapter index
                                    let chapIndex = chaptersViewModel.selectedChapterIndex
                                    
                                    /// Getting index of question and the status of the question
                                    let index = chaptersViewModel.selectedChapter!.playgroundArr.firstIndex(of: question)
                                    
                                    /// Getting question status
                                    let questionStatus = chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionProgress[index!]
                                    
                                    
                                    if (questionStatus == "incomplete"){
                                        
                                        /// First question
                                        if (index == 0){
                                            Button{
                                                chapterContentViewModel.selectedQuestionIndex = index!
                                                chapterContentViewModel.setupPlayground(question: question, questionIndex: index!, userAnswers: chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index!].answers)
                                            }label: {
                                                VStack{
                                                    Image(systemName: "chevron.right")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 30, height: 30)
                                                        .accessibilityLabel("Start Question Button")
                                                }.frame(width: 115, height: 115)
                                                
                                            }
                                            .frame(width: 115, height: 115)
                                            .background(Color.yellow)
                                            
                                        }
                                        
                                        /// Not first question
                                        else{
                                            
                                            /// Getting previous question status
                                            let statusBefore = chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionProgress[index!-1]
                                            
                                            if (statusBefore == "complete"){
                                                
                                                Button{
                                                    chapterContentViewModel.selectedQuestionIndex = index!
                                                    chapterContentViewModel.setupPlayground(question: question, questionIndex: index!, userAnswers: chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index!].answers)
                                                }label: {
                                                    
                                                    VStack{
                                                        Image(systemName: "chevron.right")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                            .accessibilityLabel("Start Question Button")
                                                    }.frame(width: 115, height: 115)
                                                    
                                                }
                                                .frame(width: 115, height: 115)
                                                .background(Color.yellow)
                                                
                                            }else{
                                                
                                                Button{
                                                    print("tapped")
                                                }label: {
                                                    
                                                    VStack{
                                                        Image(systemName: "chevron.right")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                            .accessibilityLabel("Start Question Button")
                                                    }.frame(width: 115, height: 115)
                                                    
                                                }
                                                .frame(width: 115, height: 115)
                                                .background(Color.lightGrayCustom)
                                                .disabled(true)
                                            }
                                        }
                                    }
                                    
                                    
                                    else{
                                        Button{
                                            chapterContentViewModel.selectedQuestionIndex = index!
                                            chapterContentViewModel.setupPlayground(question: question, questionIndex: index!, userAnswers: chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionAnswers[index!].answers)
                                        }label: {
                                            
                                            VStack{
                                                Image(systemName: "chevron.right")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .accessibilityLabel("Start Question Button")
                                            }.frame(width: 115, height: 115)
                                            
                                        }
                                        .frame(width: 115, height: 115)
                                        .background(Color.green)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width/1.5, height: 115)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(15)
                            .padding(5)
                        }
                        
                    }.frame(width: geometry.size.width/1.15)
                    
                    /// HStack for next chapter button
                    HStack{
                        
                        Group{
                            
                            /// If it's not the last chapter in the classroom
                            if (chaptersViewModel.chaptersArr.firstIndex(of: chaptersViewModel.selectedChapter!) != chaptersViewModel.chaptersArr.count-1){
                                
                                /// Only showing next chapter button if user is finished playground questions
                                Group {
                                    
                                    /// Chapter index
                                    let chapIndex = chaptersViewModel.selectedChapterIndex
                                    
                                    if chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].questionProgress.contains("incomplete")
                                    {
                                        Button{
                                            
                                        }label:{
                                            ButtonLabelLarge(text: "Next Chapter", textColor: .white, backgroundColor: Color(UIColor.systemGray))
                                                .opacity(0.5)
                                        }
                                        .frame(width: geometry.size.width, alignment: .center)
                                        .padding(20)
                                        .disabled(true)
                                        .accessibilityLabel("Start Next Chapter Button")
                                    } else{
                                        Button{
                                            print("Show ad")
                                            self.fullScreenAd?.showAd()
                                            chaptersViewModel.willStartNextChapter = true
                                            chapterContentViewModel.willStartInteractiveSection.toggle()
                                            chaptersViewModel.didStartChapter.toggle()
                                        }label:{
                                            NextChaptButton(text: "Next Chapter", textColor: .white, backgroundColor: Color(UIColor.systemGreen))
                                        }
                                        .frame(width: geometry.size.width, alignment: .center)
                                        .padding(20)
                                        .accessibilityLabel("Start Question Button")
                                    }
                                }
                            }
                        }
                    }
                    
                    /// Navigation link for starting a playground question
                    NavigationLink(destination: InteractiveView()
                                    .environmentObject(chaptersViewModel)
                                    .environmentObject(chapterContentViewModel),
                                   isActive: $chapterContentViewModel.willStartPlaygroundQuestion) {EmptyView()}
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        
        .onAppear(){
            
            let chapIndex = chaptersViewModel.selectedChapterIndex
            
            let userTheoryProgress = chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].theoryStatus
            let userPlaygroundProgress = chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].playgroundStatus
            
            /// If user theory progress is inprogress
            if (userTheoryProgress == "inprogress"){
                
                /// Set theory progress to complete
                chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].theoryStatus = "complete"
            }
            
            /// If the user playground progress is incomplete
            if (userPlaygroundProgress == "incomplete"){
                
                /// Set playground status and classroom playground status to inprogress
                chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].playgroundStatus = "inprogress"
                chaptersViewModel.loggedInUser.classroom[0].classroomPlaygroundStatus = "inprogress"
            }
            
            chaptersViewModel.saveUserProgressToCloud { status in
            }
            
            chaptersViewModel.retrieveUserbaseCompletion(completion: { _ in })
            
            /// If all the questions in this playground are complete, set the chapter to be complete
            if (chapterContentViewModel.playgroundQuestionStatus.contains("incomplete")){
                print("Chapter incomplete")
            } else{
                chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].playgroundStatus = "complete"
                chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].chapterStatus = "complete"
                chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].theoryStatus = "complete"

                chaptersViewModel.chaptersStatus[chapIndex] = "complete"
            }
        }
    }
}

/// Preview
struct InteractiveQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveQuestionsView()
    }
}
