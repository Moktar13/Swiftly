//
//  ChapterQuizView.swift
//  Swiftly
//
//  Created by Toby Moktar on 2021-10-12.
//

import SwiftUI

struct ChapterQuizView: View {
    
    
    /// Used to manually pop from nav view stack
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack{
                
                Color.blackCustom
                    .ignoresSafeArea()
                
                VStack{
                    HStack {
                        
                        Button{
                            chaptersViewModel.didStartChapter.toggle()
                            
                        }label:{
                            ChapterNavBarIcon(iconName: "xmark")
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                    }
                    .padding(.top, geometry.size.width/16)
                    .padding(.bottom, geometry.size.width/16)
                    
                    Spacer()
                    /// Todo: Tab View
                    
                }
            }
            
            
        }
        .navigationBarHidden(true)
        
        
     
    }
}

struct ChapterQuizView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterQuizView()
    }
}
