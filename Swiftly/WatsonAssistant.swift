//  INFO49635 - CAPSTONE FALL 2022
//  WatsonAssistant.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI
import AssistantV2


/// Struct for message object
struct Message: Identifiable {
    var id = UUID()
    var text: String
    var sender: Sender
    
    enum Sender{
        case user, chatbot, system
    }
}

class WatsonAssistant: ObservableObject {
    
    static let instance = WatsonAssistant()
    private let authenticator = WatsonIAMAuthenticator(apiKey: "hqEd_vDM2H5RYGbupGdbTGN2RXUNd1Hmj9NsWZFX8Kp8")
    private let assistant: Assistant
    private let assistantID = "ed64f467-13e6-446a-9b16-202390d33340"
    private var context: MessageContextStateless = MessageContextStateless()

    init(){
        assistant = Assistant(version: "2020-06-14", authenticator: authenticator)
        assistant.serviceURL = "https://api.us-south.assistant.watson.cloud.ibm.com/instances/25a8489b-6fcb-414e-9f8c-a41622bbd978"
    }


    func sendTextToAssistant(text: String, completion: @escaping(Result<MessageResponseStateless,WatsonError>) -> Void) {
        
        let input = MessageInputStateless(messageType: "text", text: text)

        self.assistant.messageStateless(assistantID: self.assistantID, input: input, context: context){ (response, error) in

            guard let result = response?.result else {

                print("Error occured. ")
                completion(.failure(WatsonError.noResponse))
                return
            }
            
            self.context = result.context

            completion(.success(result))

        }
    }
    
    func processGenericResponse(assistantResponse: [RuntimeResponseGeneric]) -> String {
      
        var message = ""
        
        SwiftlyApp.incomingChatbotMessages.removeAll()
        
        for response in assistantResponse {
            switch response {
            case let .text(innerResponse):
                message = innerResponse.text
                let newMessage = Message(text: message, sender: Message.Sender.chatbot)
                /// saving response in static array of messages
                SwiftlyApp.incomingChatbotMessages.append(newMessage)
            default:
                return "Something went wrong..."
            }
        }
        
        return message
    }
}
