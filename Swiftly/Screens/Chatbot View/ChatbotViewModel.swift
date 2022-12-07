//  INFO49635 - CAPSTONE FALL 2022
//  ChatbotViewModel.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI
import AssistantV2

final class ChatbotViewModel: ObservableObject {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Published var allMessages: [Message] = []
    
    private let chatbot = WatsonAssistant.instance
    
    enum MessageStatus {
        case pending, sent, received
    }
    
    var chatlog: [(status: MessageStatus, text: String)] = []
    
    /// Sending message to chatbot
    func send(text: String) {
        
        chatlog.append((MessageStatus.sent, text))
        
        // Adding user sent message to array
        allMessages.append(Message(text: text, sender: Message.Sender.user))

        chatbot.sendTextToAssistant(text: text) { result in
            
            switch result {
                
            case .success(let response):
                
                if let generic = response.output.generic {
                    self.chatlog.append((MessageStatus.received, self.chatbot.processGenericResponse(assistantResponse: generic)))
                }else {
                    self.chatlog.append((MessageStatus.received, "Invalid Response."))
                }
                
                print(self.chatlog)
                
            default:
                self.chatlog.append((MessageStatus.received, "Chatbot is offline. Try again later."))
            }
        }
        
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.migrateMessage()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showAll()
        }
    }
    
    /// migrating chatbot's message data with user message data
    func migrateMessage(){
        print("COUNT: \(SwiftlyApp.incomingChatbotMessages.count)")
        for index in 0..<SwiftlyApp.incomingChatbotMessages.count {
            
            allMessages.append(Message(text:SwiftlyApp.incomingChatbotMessages[index].text, sender: SwiftlyApp.incomingChatbotMessages[index].sender))
        }
    }
    
    /// showing all the messages -- debug purpose
    func showAll(){
        print("** SHOW ALL **")
        for index in 0..<allMessages.count {
            print(allMessages[index].text)
        }
    }
}
