//  INFO49635 - CAPSTONE FALL 2022
//  ChapterDetailView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

/// TODO: Chapter completion status has to come from the student collection not the chapter one.

struct ChapterDetailView: View {
    
    let chapter = MockData.sampleChapter
    
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel // view model for this view
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    @EnvironmentObject var leaderboardViewModel: LeaderboardViewModel
    
    // Connected to chaptersViewModel isShowingDetail
    @Binding var isShowingDetailView: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack{
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading){
                    
                    HStack{
                        
                        TitleLabel(text: "Chapter \(chaptersViewModel.selectedChapter!.chapterNum)")
                            .padding(.trailing, -geometry.size.width/12)
                            .padding(.leading, geometry.size.width/12)
                            .accessibilityLabel("Chapter \(chaptersViewModel.selectedChapter!.chapterNum)")
                        
                        Spacer()
                        
                        Button {
                            isShowingDetailView = false
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .imageScale(.large)
                                .foregroundColor(Color(UIColor.systemGray3))
                                .frame(width: 25, height: 25)
                                .accessibilityLabel("Close Button")
                        }
                        .padding(.trailing, geometry.size.width/12)
                        .padding(.leading, -geometry.size.width/12)
                    }
                    
                    HStack{
                        
                        Text("\(chaptersViewModel.selectedChapter!.name)")
                            .font(.system(size: 35, weight: .bold, design: .default))
                            .accessibilityLabel("\(chaptersViewModel.selectedChapter!.name)")
                        
                        Image(systemName: "\(chaptersViewModel.selectedChapter!.iconName)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                    }
                    .padding(.trailing, -geometry.size.width/12)
                    .padding(.leading, geometry.size.width/12)
                    .padding(.top, -geometry.size.width/24)
                    
                    VStack(alignment: .leading){
                        
                        VStack(alignment: .leading, spacing: -geometry.size.width/48){
                            
                            ChapterContentText(text: "Estimated Length: \(chaptersViewModel.selectedChapter!.length) minutes")
                                .accessibilityLabel("Estimated Length: \(chaptersViewModel.selectedChapter!.length) minutes")
                            
                            ChapterContentText(text: "Difficulty Level: \(chaptersViewModel.selectedChapter!.difficulty)")
                                .accessibilityLabel("Difficulty Level: \(chaptersViewModel.selectedChapter!.difficulty)")
                            
                            Group{
                                
                                let chapter = chaptersViewModel.selectedChapter
                                let index = chaptersViewModel.chaptersArr.firstIndex(of: chapter!)
                                let status = chaptersViewModel.loggedInUser.classroom[0].chapterProgress[index!].chapterStatus
                             
                                ChapterContentText(text: "Status: \(status.capitalizingFirstLetter())")
                                    .accessibilityLabel("Status: \(status.capitalizingFirstLetter())")
                            }
                            ChapterContentText(text: chaptersViewModel.selectedChapter!.summary)
                                .padding(.trailing, geometry.size.width/6)
                                .padding(.top, geometry.size.width/24)
                                .minimumScaleFactor(0.5)
                                .accessibilityLabel(chaptersViewModel.selectedChapter!.summary)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            chaptersViewModel.selectedChapterIndex = chaptersViewModel.chaptersArr.firstIndex(of: chaptersViewModel.selectedChapter!)!
                            isShowingDetailView = false
                            chaptersViewModel.startChapterIntent = true
                            
                        } label: {
                            StartChapterButton(text: "Start Chapter", textColor: .white, backgroundColor: Color(UIColor.darkGray))
                                .accessibilityLabel("Start Chapter Button")
                        }
                        .padding(.leading, geometry.size.width/12)
                        
                        Group{
                            let chapIndex = chaptersViewModel.chaptersArr.firstIndex(of: chaptersViewModel.selectedChapter!)
                            let chapterStat = chaptersViewModel.chaptersStatus[chapIndex!]
                            let completionCount = chaptersViewModel.userCompletionCount[chapIndex!]

                            if (completionCount == 1){
                                Text("\(completionCount) student out of \(chaptersViewModel.totalUserCount) have completed this chapter")
                                    .font(.system(size: 20,weight: .bold,design: .default))
                                    .foregroundColor(Color(UIColor.systemOrange))
                                    .padding(.leading, geometry.size.width/8.5)
                                    .accessibilityLabel("\(completionCount) student out of \(chaptersViewModel.totalUserCount) have completed this chapter")
                            }else{
                                Text("\(completionCount) students out of \(chaptersViewModel.totalUserCount) have completed this chapter")
                                    .font(.system(size: 20,weight: .bold,design: .default))
                                    .foregroundColor(Color(UIColor.systemOrange))
                                    .padding(.leading, geometry.size.width/8.5)
                                    .accessibilityLabel("\(completionCount) students out of \(chaptersViewModel.totalUserCount) have completed this chapter")
                            }
                        }
                    
                        VStack(alignment: .leading){
                            
                            ChapterContentText(text: "Jump To")
                                .accessibilityLabel("Jump To")
                            
                            HStack(spacing: geometry.size.width/32){
                                
                                Group{
                                    
                                    /// Getting chapter index
                                    let chapIndex = chaptersViewModel.chaptersArr.firstIndex(of: chaptersViewModel.selectedChapter!)
                                 
                                    /// Grabbing playground status
                                    let playgroundStat = chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex!].playgroundStatus
                                    
                                    /// Checking playground stat for the "Jump To" button
                                    if (playgroundStat == "incomplete"){
                                        
                                        Button{
                                            print("tapped")
                                        }label: {
                                            ChapterDetailsButtonText(text: "Questions")
                                                .accessibilityLabel("Questions")
                                        }
                                        .frame(width: 260, height: 50)
                                        .background(Color.lightGrayCustom)
                                        .cornerRadius(10)
                                        .disabled(true)
                                        
                                        
                                        Button{
                                            print("tapped")
                                        }label: {
                                            ChapterDetailsButtonText(text: "Leaderboard")
                                                .accessibilityLabel("Leaderboard")
                                        }
                                        .frame(width: 260, height: 50)
                                        .background(Color.lightGrayCustom)
                                        .cornerRadius(10)
                                        .disabled(true)
                                    }
                                    
                                    else if (playgroundStat == "inprogress"){
                                        
                                        Button{
                                            chaptersViewModel.selectedChapterIndex = chaptersViewModel.chaptersArr.firstIndex(of: chaptersViewModel.selectedChapter!)!
                                            isShowingDetailView = false
                                            chaptersViewModel.startChapterIntent = true
                                            chaptersViewModel.jumpToPlayground = true
                                        }label: {
                                            ChapterDetailsButtonText(text: "Questions")
                                                .accessibilityLabel("Questions")
                                        }
                                        .frame(width: 260, height: 50)
                                        .background(Color(UIColor.systemYellow))
                                        .cornerRadius(10)
                                        .disabled(false)
                                        
                                        Button{
                                            print("tapped")
                                        }label: {
                                            ChapterDetailsButtonText(text: "Leaderboard")
                                                .accessibilityLabel("Leaderboard")
                                        }
                                        .frame(width: 260, height: 50)
                                        .background(Color.lightGrayCustom)
                                        .cornerRadius(10)
                                        .disabled(true)
                                    }
                                    
                                    else if (playgroundStat == "complete"){
                                      
                                        Button{
                                            chaptersViewModel.selectedChapterIndex = chaptersViewModel.chaptersArr.firstIndex(of: chaptersViewModel.selectedChapter!)!
                                            isShowingDetailView = false
                                            chaptersViewModel.startChapterIntent = true
                                            chaptersViewModel.jumpToPlayground = true
                                        }label: {
                                            ChapterDetailsButtonText(text: "Questions")
                                                .accessibilityLabel("Questions")
                                        }
                                        .frame(width: 260, height: 50)
                                        .background(Color(UIColor.systemGreen))
                                        .cornerRadius(10)
                                        .disabled(false)
                                        
                                        
                                        Button{
                                            leaderboardViewModel.selectedFilter = "Chapter \(chaptersViewModel.selectedChapter!.chapterNum)"
                                            chaptersViewModel.isShowingLeaderboardView.toggle()
                                            isShowingDetailView = false
                                        }label: {
                                            ChapterDetailsButtonText(text: "Leaderboard")
                                                .accessibilityLabel("Leaderboard")
                                        }
                                        .frame(width: 260, height: 50)
                                        .background(Color(UIColor.systemGreen))
                                        .cornerRadius(10)
                                        .disabled(false)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width, alignment: .leading)
                        }
                        Spacer()
                    }
                    .padding(.trailing, -geometry.size.width/12)
                    .padding(.leading, geometry.size.width/12)
                }
                .padding(.top, geometry.size.width/12)
            }
        }
        
        .onDisappear {
            /// This is done so that the sheet can be dismissed before the chapter content view
            /// is presented.
            if (chaptersViewModel.startChapterIntent){
                
                /// Setting chapter data to chapterContentView
                chapterContentViewModel.chapter = chaptersViewModel.selectedChapter!
                chapterContentViewModel.setupPlaygroundQuestions(selectedChapter: chaptersViewModel.selectedChapter!)
                
                /// Resetting intentt and telling chaptersViewModel to start the chapter
                chaptersViewModel.startChapterIntent = false
                chaptersViewModel.startChapter()
            }
        }
    }
}


//struct ChapterDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChapterDetailView()
//    }
//}


/// Struct representing the label on a button
struct StartChapterButton: View {
    
    var text: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 40))
            .fontWeight(.medium)
            .padding()
            .frame(width: 500, height: 110)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(15)
    }
}


struct ChapterContentText: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 30))
            .padding(.top, 25)
    }
    
    
}


struct ChapterDetailsButtonText: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 25))
            .foregroundColor(Color(UIColor.systemGray6))
            .background(Color(UIColor.clear))
        
    }
}
