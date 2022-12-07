//  INFO49635 - CAPSTONE FALL 2022
//  SignupView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var monitor = NetworkMonitor()
    
    
    var userTypes = ["Student", "Teacher"]
    var countries = ["Canada", "United States", "United Kingdom", "Australia", "Ireland", "Scotland", "New Zealand"]
    
    @State private var selectedType = "Student"
    
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var signupViewModel: SignupViewModel /// view model for this view
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            ZStack {
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Button{
                            loginViewModel.isShowingSignupView.toggle()
                        }label:{
                            NavBarIcon(iconName: "chevron.backward")
                        }
                        .padding(.leading, 30)
                        .disabled(signupViewModel.loadingSignupProcess)

                        Spacer()
                    }
                    .padding(.top, geometry.size.width/24)
                    .padding(.bottom, geometry.size.width/24)
                    
                    // Title
                    TitleLabel(text:"Account Creation")
                        .padding(.bottom, geometry.size.width/42)
                        .accessibilityLabel("Account Creation")
                    
                    // Username
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text:"Username")
                            .padding(.bottom, -geometry.size.width/120)
                        
                        TextField("Username", text : $signupViewModel.newUser.username)
                            .font(.system(size: 30))
                            .padding()
                            .autocapitalization(.none)
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)
                            .accessibilityLabel("Username")
                        Text("Must be 5-15 characters in length, start with a letter and only contain a _ or . after a letter.")
                            .font(.system(size: 15))
                            .accessibilityLabel("Must be 5-15 characters in length, start with a letter and only contain a _ or . after a letter.")
                        
                    }
                    .padding(geometry.size.width/42)
                         
                    
                    // First and last name
                    HStack(spacing:geometry.size.width/18){
                        
                        VStack(alignment: .leading){
                           
                            InputFieldLabel(text:"First Name")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("First Name")
                            
                            TextField("First Name", text : $signupViewModel.newUser.firstName)
                                .font(.system(size: 30))
                                .padding()
                                .autocapitalization(.none)
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color(UIColor.systemGray3))
                                .cornerRadius(15)
                        }
                        
                        VStack(alignment: .leading) {
                           
                            InputFieldLabel(text:"Last Name")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("Last Name")

                            TextField("Last Name", text : $signupViewModel.newUser.lastName)
                                .font(.system(size: 30))
                                .padding()
                                .autocapitalization(.none)
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color(UIColor.systemGray3))
                                .cornerRadius(15)
                        }
                    }.padding(geometry.size.width/42)
                    
                    // Country and DOB
                    HStack(spacing:geometry.size.width/18){
                        
                        VStack(alignment: .leading){
                            
                            InputFieldLabel(text:"Country")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("Country")
                            
                            Picker("", selection: $signupViewModel.newUser.country) {
                                            ForEach(countries, id: \.self) {
                                                           
                                                Text($0)
                                                    .font(.system(size: 30))
                                            }
                                        }
                            .frame(width: 100, height: 50)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(10)
                            
                        }
                        
                        VStack(alignment: .leading) {
                            
                            InputFieldLabel(text:"Date of Birth")
                                .padding(.bottom, -geometry.size.width/120)
                                .accessibilityLabel("Date of Birth")
                            
                            TextField("DD/MM/YYYY", text : $signupViewModel.newUser.dob)
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
                        
                        InputFieldLabel(text:"Email Address")
                            .padding(.bottom, -geometry.size.width/120)
                            .accessibilityLabel("Email Address")
                        
                        TextField("Email", text : $signupViewModel.newUser.email)
                            .font(.system(size: 30))
                            .padding()
                            .autocapitalization(.none)
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)

                        
                    }
                    .padding(geometry.size.width/42)
                    
                    // Password
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text:"Password")
                            .padding(.bottom, -geometry.size.width/120)
                            .accessibilityLabel("Password")
                        
                        SecureInputView("Password", text : $signupViewModel.newUser.password)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)
                        
                        Text("Must be 8-15 characters in length, start with a letter, and contain atleast 1 number")
                            .font(.system(size: 15))
                            .accessibilityLabel("Must be 8-15 characters in length, start with a letter, and contain atleast 1 number")
                        
                    }
                    .padding(geometry.size.width/42)
                    
                    /*
                    HStack{
                        
                        InputFieldLabel(text:"User Type: ")
                        
                        
                        Picker("", selection: $selectedType) {
                                        ForEach(userTypes, id: \.self) {
                                                       
                                            Text($0)
                                                .font(.system(size: 30))
                                        }
                                    }
                        .frame(width: 100, height: 50)
                        .background(Color.blackCustom)
                        .cornerRadius(15)
                        
                    }
                     */
                    
                    // Create account button
                    Button{
                        
                        signupViewModel.doesNameContainProfanity = false
                        signupViewModel.isBadSignup = false
                        
                        // Validating username,firstname and lastname
                        if signupViewModel.validateName(name: signupViewModel.newUser.username) || signupViewModel.validateName(name: signupViewModel.newUser.firstName) || signupViewModel.validateName(name: signupViewModel.newUser.lastName) {
                            signupViewModel.doesNameContainProfanity.toggle()
                            signupViewModel.showAlert.toggle()
                        } else {
                            
                            signupViewModel.loadingSignupProcess = true
                            
                            signupViewModel.saveNewUser { status in
                                switch status {
                                case .success:
                                    signupViewModel.isBadSignup = false
                                    loginViewModel.isShowingSignupView.toggle()
                                case .failure, .unknown:
                                    signupViewModel.isBadSignup = true
                                    signupViewModel.showAlert = true
                                }
                                
                                signupViewModel.loadingSignupProcess = false
                            }
                        }
                    } label:{
                        CreateAccountButton(text: "Create Account", textColor: .white, backgroundColor: Color.blackCustom)
                            .accessibilityLabel("Create Account")
                        
                    }
                    .opacity(signupViewModel.isSignUpComplete || monitor.isConnected ? 1 : 0.25)
                    .disabled(!monitor.isConnected || !signupViewModel.isSignUpComplete || signupViewModel.loadingSignupProcess)
                    
                    if (!monitor.isConnected){
                        Text("Connect to the internet if you want to create a new account")
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                            .accessibilityLabel("Connect to the internet if you want to create a new account")
                    }
                }

                
                .alert(isPresented: $signupViewModel.showAlert) {
                    switch signupViewModel.getAlertType() {
                    case .profanity:
                        return Alert(title: Text("Profanity Detected!"), message: Text("Please enter a username, first and last name with no profanity."), dismissButton: .default(Text("OK")))
                        
                    case .badSignup:
                        return Alert(title: Text("Email Already Taken"), message: Text("\(signupViewModel.newUser.email) is already taken."), dismissButton: .default(Text("OK")))
                    }
                }

                Spacer()
                    .onAppear(){
                        signupViewModel.chaptersArr = chaptersViewModel.chaptersArr
                        signupViewModel.newUser.email = ""
                        signupViewModel.newUser.username = ""
                        signupViewModel.newUser.password = ""
                        signupViewModel.newUser.firstName = ""
                        signupViewModel.newUser.lastName = ""
                        signupViewModel.newUser.dob = ""                        
                    }
            }
            .navigationBarHidden(true)
        }
    }
}

// Preview
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

// Struct representing input field label
struct InputFieldLabel: View {
    
    var text:String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 25))
        
    }
}


// Struct representing the label on a button
struct CreateAccountButton: View {
    
    var text: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 35))
            .fontWeight(.semibold)
            .padding()
            .frame(width: 400, height: 75)
            .background(Color(UIColor.systemGray2))
            .cornerRadius(15)
    }
}


struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if isSecured {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
            }
        }
    }
}
