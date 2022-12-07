//  INFO49635 - CAPSTONE FALL 2022
//  ChapterContentView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI
import UIKit

/// TODO: Pass more view models down here (if needed to update student stats)
/// TODO: Might have to think of a better way to present theoretical data, because not every chapter will have exactly
/// three screens and so on. Might have to use a grid view where each cell is the size of the screen.

struct ChapterContentView: View {
    
    
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel /// view model for this view
    @EnvironmentObject var chatbotViewModel: ChatbotViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack{
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack{
                    
                    HStack {
                        
                        Button{
                            chaptersViewModel.didStartChapter.toggle()
                        }label:{
                            NavBarIcon(iconName: "chevron.backward")
                                .accessibilityLabel("Back Button")
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                        
                        
                        Button{
                            chapterContentViewModel.isShowingChabot.toggle()
                        }label:{
                            NavBarIcon(iconName: "questionmark")
                                .accessibilityLabel("Chatbot Button")
                        }
                        .padding(.trailing, 30)
                        .fullScreenCover(isPresented: $chapterContentViewModel.isShowingChabot){
                            ChatbotView()
                                .environmentObject(chatbotViewModel)
                                .environmentObject(chapterContentViewModel)
                        }
                       
                    }
                    .padding(.top, geometry.size.width/16)
                    .padding(.bottom, geometry.size.width/16)
                    

                    TabView {
                        /// Looping through each lesson
                        ForEach(0..<chaptersViewModel.selectedChapter!.lessons.count) { i in
                            
                            let lesson = chaptersViewModel.selectedChapter!.lessons[i]
                            
                            /// If it's not the last chapter
                            if (i != chaptersViewModel.selectedChapter!.lessons.count-1){
                                
                                /// Vertical scroll view for each lesson
                                ScrollView(.vertical, showsIndicators: true) {
                                    
                                    VStack(alignment: .leading){
                                        
                                        /// Going through the content for each section
                                        ForEach(lesson.content, id: \.self) { content in
                                            
                                            if (lesson.content.firstIndex(of: content) == 0){
                                                ChapterSubTitle(text: content)
                                                    .padding(.leading, geometry.size.width/24)
                                                    .accessibilityLabel(content)
                                            }else{
                                                
                                                if (content.starts(with: "data:image")){
                                                    
                                                    let imgBase64 = chapterContentViewModel.getBase64(original: content)
                                                    
                                                    HStack{
                                                        Spacer()
                                                        Image(base64String: String(imgBase64))!
//                                                            .resizable()
//                                                            .aspectRatio(contentMode: .fit)
//                                                            .frame(width: geometry.size.width/1.50)
                                                        Spacer()
                                                    }
                                                    .padding(.bottom, geometry.size.width/48)
                                                    
                                                }else{
                                                    InteractiveContentText(text: content)
                                                        .padding(.leading, geometry.size.width/24)
                                                        .padding(.bottom, geometry.size.width/48)
                                                        .padding(.trailing, geometry.size.width/24)
                                                        .accessibilityLabel(content)
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width, alignment: .leading)
                                }
                            }else{
                                
                                VStack{
                                    
                                    ScrollView(.vertical, showsIndicators: true) {
                                        
                                        VStack(alignment: .leading){
                                            
                                            /// Going through the content for each section
                                            ForEach(lesson.content, id: \.self) { content in
                                                
                                                if (lesson.content.firstIndex(of: content) == 0){
                                                    ChapterSubTitle(text: content)
                                                        .padding(.leading, geometry.size.width/24)
                                                        .accessibilityLabel(content)
                                                }else{
                                                    
                                                    if (content.starts(with: "data:image")){
                                                        
                                                        let imgBase64 = content.dropFirst(22)
                                                        
                                                        HStack{
                                                            Spacer()
                                                            
                                                            if let _ = Image(base64String: String(imgBase64)) {
                                                                Image(base64String: String(imgBase64))!
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: geometry.size.width/1.50)
                                                                Spacer()
                                                            }
                                                            
                                                            
                                                        }
                                                        .padding(.bottom, geometry.size.width/48)
                                                        
                                                    }else{
                                                        InteractiveContentText(text: content)
                                                            .padding(.leading, geometry.size.width/24)
                                                            .padding(.bottom, geometry.size.width/48)
                                                            .padding(.trailing, geometry.size.width/24)
                                                            .accessibilityLabel(content)
                                                    }
                                                }
                                            }
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Spacer()
                                            
                                            Button{
                                                chapterContentViewModel.startInteractiveSection()
                                            }label: {
                                                Text("Start Interactive Section")
                                                    .font(.system(size: 30, weight: .semibold))
                                                    .accessibilityLabel("Start Interactive Section Button")
                                            }
                                            .frame(width: geometry.size.width/2, height: geometry.size.height/12)
                                            .background(Color(UIColor.darkGray))
                                            .cornerRadius(15)
                                            
                                            Spacer()
                                        }
                                        
                                        .padding(.top, geometry.size.width/24)
                                        .padding(.bottom, geometry.size.width/12)
                                    }
                                }
                                .frame(width: geometry.size.width, alignment: .leading)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height/1.10)
                    .padding(.top, 10)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            
            NavigationLink(destination: InteractiveQuestionsView()
                            .environmentObject(chaptersViewModel)
                            .environmentObject(chapterContentViewModel),
                           isActive: $chapterContentViewModel.willStartInteractiveSection) {EmptyView()}
        }
        .navigationBarHidden(true)
        
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if (chaptersViewModel.jumpToPlayground == true){
                    chapterContentViewModel.startInteractiveSection()
                    chaptersViewModel.jumpToPlayground = false
                }
            }
            /// Getting chapter index
            let chapIndex = chaptersViewModel.selectedChapterIndex
            
            /// Getting user theory progress for chapter
            let userTheoryProgress = chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].theoryStatus
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            
                /// If it's incomplete, set it to inprogress
                if (userTheoryProgress == "incomplete"){
                    
                    /// Setting chapter theory and chapter status to inprogress
                    chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].theoryStatus = "inprogress"
                    chaptersViewModel.loggedInUser.classroom[0].chapterProgress[chapIndex].chapterStatus = "inprogress"
                    
                    /// Used to update UI
                    chaptersViewModel.chaptersStatus[chapIndex] = "inprogress"
                    
                    /// Grabbing the classroom theory, and setting it to progress if it's incomplete (not started)
                    let classroomTheoryProgress = chaptersViewModel.loggedInUser.classroom[0].clasroomTheoryStatus
                    
                    if (classroomTheoryProgress == "incomplete"){
                        chaptersViewModel.loggedInUser.classroom[0].clasroomTheoryStatus = "inprogress"
                        chaptersViewModel.loggedInUser.classroom[0].classroomStatus = "inprogress"
                    }
                    
    //                chaptersViewModel.saveUserProgress()
                }
            
                chaptersViewModel.saveUserProgressToCloud(completion: { status in
                    print(status)
                })
            
            }
        }
    }
}

struct ChapterContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterContentView()
    }
}

/// struct representing chapter topic
struct ChapterTopic: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 40,
                          weight: .bold,
                          design: .default))
            
    }
}


/// Struct representing chapter icon
struct ChapterTopicIcon: View {
    
    var iconName: String
    
    var body: some View {
        
        Image(systemName: iconName)
            .resizable()
            .frame(width: 40, height: 40)
            
        
    }
}

struct ChapterSubTitle: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 40,
                          weight: .bold,
                          design: .default))
            
    }
}


extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
}
