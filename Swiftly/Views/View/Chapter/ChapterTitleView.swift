//  INFO49635 - CAPSTONE FALL 2022
//  ChapterTitleView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct ChapterTitleView: View {
    
    let chapter: Chapter
    
    var width: CGFloat
    
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    @EnvironmentObject var leaderboardViewModel: LeaderboardViewModel
    
    var body: some View {
        
        VStack{
            
            VStack(alignment: .leading, spacing: 5){
                
                HStack{
                    Text("Chapter \(chapter.chapterNum)")
                        .font(.system(size: 35))
                        .padding(.leading, 10)
                        .accessibilityLabel("Chapter \(chapter.chapterNum)")
                    
                    Spacer()
                    
                    Group{
                        
                        let chapIndex = chaptersViewModel.chaptersArr.firstIndex(of: chapter)
                        let chapterStat = chaptersViewModel.chaptersStatus[chapIndex!]
                        
                        if (chapterStat == "complete"){
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(10)
                                .foregroundColor(Color(UIColor.systemGreen))
                        }else if (chapterStat == "inprogress"){
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(10)
                                .foregroundColor(Color.yellow)
                        }else{
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(10)
                                .foregroundColor(Color.lightGrayCustom)
                        }
                    }
                }.frame(width: width)
                
                ChapterInfoLabel(text: "\(chapter.name)")
                    .accessibilityLabel("\(chapter.name)")
                ChapterInfoLabel(text: "Estimated Length: \(chapter.length)")
                    .accessibilityLabel("Estimated Length: \(chapter.length)")
                
                HStack{
                    ChapterInfoLabel(text: "Difficulty: ")
                        .accessibilityLabel("Difficuluty: \(chapter.difficulty)")
                    
                    ForEach(1..<chapter.difficulty+1) { index in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .minimumScaleFactor(0.5)
                }
  
                Spacer()
                
                Group{
                    
                    let chapIndex = chaptersViewModel.chaptersArr.firstIndex(of: chapter)
                    let chapterStat = chaptersViewModel.chaptersStatus[chapIndex!]
                    
                    let completionCount = chaptersViewModel.userCompletionCount[chapIndex!]
                    
                    ChapterInfoLabel(text: "Completion Count: \(completionCount)")
                        .accessibilityLabel("Completion Count: \(completionCount)")
                    
                    if (chapterStat == "incomplete"){
                        HStack{
                            Button{
                                chaptersViewModel.selectedChapter = chapter
                                chaptersViewModel.selectedChapterIndex = chaptersViewModel.chaptersArr.firstIndex(of: chaptersViewModel.selectedChapter!)!
                            } label: {
                                Text("Select Chapter")
                                    .font(.system(size: 20, weight: .semibold, design: .default))
                                    .foregroundColor(Color(UIColor.systemGray6))
                                    .frame(width: width, height: 60)
                                    .accessibilityLabel("Select Chapter")
                            }
                        }
                        .frame(width: width, height: 60)
                        .cornerRadius(30)
                        .background(Color.lightGrayCustom)
                        
                    }else if (chapterStat == "inprogress"){
                        HStack{
                            Button{
                                chaptersViewModel.selectedChapter = chapter
                            } label: {
                                Text("Select Chapter")
                                    .font(.system(size: 20, weight: .semibold, design: .default))
                                    .foregroundColor(Color(UIColor.systemGray6))
                                    .frame(width: width, height: 60)
                                    .accessibilityLabel("Select Chapter")
                            }
                        }
                        .frame(width: width, height: 60)
                        .cornerRadius(30)
                        .background(Color(UIColor.systemYellow))
                    }
                    else if (chapterStat == "complete"){
                        HStack{
                            Button{
                                chaptersViewModel.selectedChapter = chapter
                            } label: {
                                Text("Select Chapter")
                                    .font(.system(size: 20, weight: .semibold, design: .default))
                                    .foregroundColor(Color(UIColor.systemGray6))
                                    .frame(width: width, height: 60)
                                    .accessibilityLabel("Select Chapter")
                            }
                        }
                        .frame(width: width, height: 60)
                        .cornerRadius(30)
                        .background(Color(UIColor.systemGreen))
                    }
                }
                
            }.frame(width: width, height:275, alignment: .leading)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(15)
        }
    }
}

struct ChapterInfoLabel: View{
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .semibold))
            .padding(.leading, 10)
    }
}
