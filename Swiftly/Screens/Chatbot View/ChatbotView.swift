//  INFO49635 - CAPSTONE FALL 2022
//  ChatbotView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct ChatbotView: View {
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor(Color.white)
    }
    
    @EnvironmentObject var chatbotViewModel: ChatbotViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    @State var userMessage: String = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack{
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack{
                    
                    HStack {
                        Button {
                            chapterContentViewModel.isShowingChabot.toggle()
                        }label:{
                            ChatbotNavBarIcon(iconName: "xmark")
                                .accessibilityLabel("Close Button")
                            
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                        
                    }
                    .padding(.top, geometry.size.width/16)
                    .padding(.bottom, geometry.size.width/32)
                    
                    VStack{
                        
                        HStack{
                            
                            TitleLabel(text: "Swiftly Help")
                                .padding(.leading, 30)
                                .accessibilityLabel("Swiftly Help")
                            
                            Spacer()
                        }
                        .padding(.bottom, -10)
                        
                        /// For the messages with chatbot
                        List {

                            ForEach(chatbotViewModel.allMessages, id: \.id) { msg in
                                
                                /// If sender is user
                                if (msg.sender == Message.Sender.user){
                                    
                                    HStack{
                                        
                                        Spacer()
                                        
                                        VStack{
                                            Text(msg.text)
                                                .font(.system(size: 20, weight: .medium))
                                                .foregroundColor(Color.white)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                                .accessibilityLabel(msg.text)
                                            
                                        }
                                        .frame(alignment: .leading)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .background(Color.blackCustom)
                                        .cornerRadius(5)
                                    }
//                                    .frame(width: geometry.size.width/1.10)
                                    .listRowBackground(Color.clear)
                                    
                                    
                                /// If sender is the chatbot
                                }else if (msg.sender == Message.Sender.chatbot){
                                    HStack{
                                        
                                        
                                        VStack{
                                            Text(msg.text)
                                                .font(.system(size: 20, weight: .medium))
                                                .foregroundColor(Color.white)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 5)
                                                .accessibilityLabel(msg.text)
                                            
                                        }
                                        .frame(alignment: .leading)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .background(Color.blackCustom)
                                        .cornerRadius(5)
                                        
                                        Spacer()
                                    }
//                                    .frame(width: geometry.size.width/1.10, alignment: .leading)
                                    .listRowBackground(Color.clear)
                                }
                            }
                        }
                        .frame(width: geometry.size.width/1.10)
                        .cornerRadius(10)
                        
                        Spacer()
                        
                        HStack{
                            
                            TextField("Say something...", text: $userMessage)
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: geometry.size.width/1.2, height: 50)
                                .background(Color(UIColor.white))
                                .foregroundColor(Color(UIColor.black))
                                .cornerRadius(10)
                            
                            Spacer()
                            
                            Button{
                                chatbotViewModel.send(text: userMessage)
                                userMessage = ""
                            }label:{
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .accessibilityLabel("Send Message Button")
                            }
                            .frame(width: 44, height: 44)
                        }
                        .frame(width: geometry.size.width/1.10)
                        .padding(.bottom, 15)
                        .padding(.top, 15)
                    }.frame(width: geometry.size.width, alignment: .leading)
                    
                    Spacer()
                }
            }
        }
        .onAppear(){
            chatbotViewModel.allMessages.removeAll()
            chatbotViewModel.chatlog.removeAll()
            SwiftlyApp.incomingChatbotMessages.removeAll()
            
            chatbotViewModel.allMessages.append(Message(text: "Hi! I'm the Swiftly chatbot assistant, here to help you with any difficulties you may have ran into while working on the chapter. How may I help you?", sender: Message.Sender.chatbot))
        }
    }
}

struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}


struct ChatbotTitleLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 60, weight: .light))
            .foregroundColor(Color.whiteCustom)
    }
}


struct ChatbotNavBarIcon: View {
    var iconName: String
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .foregroundColor(Color(UIColor.systemGray2))
    }
}
