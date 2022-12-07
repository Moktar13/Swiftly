//  INFO49635 - CAPSTONE FALL 2022
//  EditAccountView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct EditAccountView: View {
    
    /// Todo: Change to @Published and move it into the viewmodel
    @State var user = MockData.sampleUser
    
    @ObservedObject var monitor = NetworkMonitor()
    
    var countries = ["Canada", "United States", "United Kingdom", "Australia", "Ireland", "Scotland", "New Zealand"]
    
    @EnvironmentObject var userAccountViewModel: UserAccountViewModel /// view model for this view
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            ZStack {
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Button{
                            userAccountViewModel.isEditingAccount.toggle()
                        }label:{
                            NavBarIcon(iconName: "xmark")
                                .accessibilityLabel("Close Page Button")
                        }
                        .padding(.leading, 30)

                        Spacer()
                    }
                    .padding(.top, geometry.size.width/24)
                    .padding(.bottom, geometry.size.width/24)
                    
                    // Title
                    TitleLabel(text: "Edit Account")
                        .padding(.bottom, geometry.size.width/42)
                        .accessibilityLabel("Edit Account")
                    
                    // Username
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text: "Username")
                            .padding(.bottom, -geometry.size.width/120)
                            .accessibilityLabel("Username")
                    
                        TextField("Username",text: $userAccountViewModel.updatedUser.username)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)
                    }
                    .padding(geometry.size.width/42)
                    .opacity(0.55)
                    .disabled(true)
                         
                    
                    // First and last name
                    HStack(spacing:geometry.size.width/18){
                        
                        VStack(alignment: .leading){
                           
                            InputFieldLabel(text: "First Name")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("First Name")
                            
                            TextField("First Name", text : $userAccountViewModel.updatedUser.firstName)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color(UIColor.systemGray3))
                                .cornerRadius(15)
                        }
                        
                        VStack(alignment: .leading) {
                           
                            InputFieldLabel(text: "Last Name")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("Last Name")

                            TextField("Last Name", text : $userAccountViewModel.updatedUser.lastName)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color(UIColor.systemGray3))
                                .cornerRadius(15)
                        }
                    }.padding(geometry.size.width/42)
                    
                    // Country and DOB
                    HStack(spacing:geometry.size.width/18){
                        
                        VStack(alignment: .leading){
                            
                            InputFieldLabel(text: "Country")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("Country")
                            
                            Picker("", selection: $userAccountViewModel.updatedUser.country) {
                                            ForEach(countries, id: \.self) {
                                                           
                                                Text($0)
                                                    .font(.system(size: 30))
                                                    .accessibilityLabel("\($0)")
                                            }
                                        }
                            .frame(width: 100, height: 50)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(10)
                            
                        }
                        
                        VStack(alignment: .leading) {
                            
                            InputFieldLabel(text: "Date of Birth")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("Date of Birth")
                            
                            TextField("Date of Birth", text : $userAccountViewModel.updatedUser.dob)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color(UIColor.systemGray3))
                                .cornerRadius(15)
                        }
                    }
                    .padding(geometry.size.width/42)
                    
                    // Email Address
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text: "Email Address")
                            .padding(.bottom, -geometry.size.width/120)
                            .accessibilityLabel("Email Address")
                        
                        TextField("Email", text : $userAccountViewModel.updatedUser.email)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .opacity(0.55)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)
                            .disabled(true)
                        
                    }
                    .padding(geometry.size.width/42)
                    
                    // Password
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text:"Password")
                            .padding(.bottom, -geometry.size.width/120)
                            .accessibilityLabel("Password")
                        
                        SecureInputView("Password", text : $userAccountViewModel.updatedUser.password)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)
                        
                    }
                    .padding(geometry.size.width/42)
                    
                    // Update account button
                    Button{
                        
                        userAccountViewModel.doesNameContainProfanity = false
                        userAccountViewModel.isBadSignup = false
                        
                        // Validating username
                        if userAccountViewModel.validateName(name: userAccountViewModel.updatedUser.firstName) || userAccountViewModel.validateName(name: userAccountViewModel.updatedUser.lastName) {
                            userAccountViewModel.doesNameContainProfanity.toggle()
                            userAccountViewModel.showAlert.toggle()
                        } else {
                            userAccountViewModel.updateAccount {
                            // Nothing
                            }
                            userAccountViewModel.isEditingAccount.toggle()
                        }
                        
                    }label:{
                        ButtonLabelLarge(text: "Save Changes", textColor: .white, backgroundColor: Color.blackCustom)
                            .padding(geometry.size.width/42)
                            .accessibilityLabel("Save Changes Button")
                    }.opacity(userAccountViewModel.isEditingComplete ? 1 : 0.6)
                        .disabled(!monitor.isConnected || !userAccountViewModel.isEditingComplete)
                    if (!monitor.isConnected){
                        Text("Connect to the internet if you want to update account information")
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                            .accessibilityLabel("Connect to the internet if you want to update account information")
                    }
                }
                
                .alert(isPresented: $userAccountViewModel.showAlert) {
                    switch userAccountViewModel.getAlertType() {
                    case .profanity:
                        return Alert(title: Text("Profanity Detected!"), message: Text("Please enter a first and last name with no profanity."), dismissButton: .default(Text("OK")))
                        
                    case .badSignup:
                        return Alert(title: Text("Email Already Taken"), message: Text("Email is already taken."), dismissButton: .default(Text("OK")))
                    }
                }
                
                Spacer()
                    .onAppear(){
                        self.userAccountViewModel.updatedUser.password = ""
                    }
            }
            .navigationBarHidden(true)
        }
    }


struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView()
    }
}
}
