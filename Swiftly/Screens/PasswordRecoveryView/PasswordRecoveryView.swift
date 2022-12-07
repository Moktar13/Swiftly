//  INFO49635 - CAPSTONE FALL 2022
//  PasswordRecoveryView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

//struct used for handling UI elements of password recovery screen
struct PasswordRecoveryView: View {
    
    @ObservedObject var monitor = NetworkMonitor()
    @State var email = ""
    
    @EnvironmentObject var passwordRecoveryViewModel: PasswordRecoveryViewModel
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            ZStack {
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Button{
                            passwordRecoveryViewModel.toggleNow.toggle()
                        }label:{
                            NavBarIcon(iconName: "chevron.backward")
                        }
                        .padding(.leading, 30)

                        Spacer()
                    }
                    .padding(.top, geometry.size.width/24)
                    .padding(.bottom, geometry.size.width/24)
                    
                    // Title
                    
                    VStack{
                        TitleLabel(text:"Password Recovery")
                            .accessibilityLabel("Password Recovery")
                    }
                    .frame(alignment: .topLeading)
                    
                    
                    
                    // Username
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text:"Email")
                            .padding(.bottom, -geometry.size.width/120)
                        
                        TextField("Email", text: self.$passwordRecoveryViewModel.email)
                            .font(.system(size: 30))
                            .padding()
                            .autocapitalization(.none)
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)
                    }
                    .padding(geometry.size.width/42)

           
                    VStack(spacing: 20){
                        
                    ///password recovery button
                        Button{
                            print("Password recovery API call")
                            passwordRecoveryViewModel.resetPassword{
                                // Nothing
                            }
                        }label: {
                            ButtonLabelLarge(text: "Reset Password", textColor: .white, backgroundColor: Color(UIColor.systemGray2))
                        }
                        .alert(item: $passwordRecoveryViewModel.alertInfo, content: { info in
                            Alert(title: Text(info.title), message: Text(info.message))
                        })
                        .opacity(passwordRecoveryViewModel.isEmailValid() || monitor.isConnected ? 1 : 0.24)
                        .disabled(!monitor.isConnected || !passwordRecoveryViewModel.isEmailValid())
                    }

                    if (!monitor.isConnected){
                        Text("Connect to the internet if you want to reset password")
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                    }
                    
                }
                .padding(.bottom, geometry.size.height - 250)

                Spacer()
                    .onAppear(){
                        self.email = ""
 
                    }
            }
            .navigationBarHidden(true)
        }
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryView()
    }
}
