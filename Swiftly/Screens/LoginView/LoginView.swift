//  INFO49635 - CAPSTONE FALL 2022
//  LoginScreen.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI
import Firebase

struct LoginView: View {
    
    @ObservedObject var monitor = NetworkMonitor()
    
    @State var email: String = ""
    @State var password: String = ""
    var accountTypeOptions = ["Student", "Teacher"]
    
    /// Environment View Models being passed down the hierarchy
    @EnvironmentObject var loginViewModel: LoginViewModel /// --> view model for this view
    @EnvironmentObject var signupViewModel: SignupViewModel
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var chapterContentViewModel: ChapterContentViewModel
    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @EnvironmentObject var leaderboardViewModel: LeaderboardViewModel
    @EnvironmentObject var passwordRecoveryViewModel: PasswordRecoveryViewModel

    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                 
                VStack {
                    
                    VStack{
                        TitleLabel(text: "Swiftly")
                            .accessibilityLabel("Swiftly")
                    }
                    .frame(alignment: .topLeading)
                    .padding(.top, 250)
                    
                    VStack(spacing: 25){
                        TextField("Email Address", text: $email)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: 400, height: 75)
                            .background(Color(UIColor.systemGray3))
                            .autocapitalization(.none)
                            .cornerRadius(15)
                            .accessibilityLabel("Email Address")
                        
                        SecureInputView("Password", text: $password)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: 400, height: 75)
                            .background(Color(UIColor.systemGray3))
                            .cornerRadius(15)
                            .accessibilityLabel("Password")
                    }
                    
                    
                    // Login Button
                    Button{
                      
                        loginViewModel.isLoading.toggle()
                        
                        if (loginViewModel.showLoginSpinner == false){
                            
                            loginViewModel.loginUser(email: email, password: password) { status in
                                switch status {
                                case .success:
                                    
                                    loginViewModel.showLoginSpinner = true
                                    loginViewModel.loggedInEmail = email
                                    
                                    chaptersViewModel.startUserDownload(email: email) { statusTwo in
                                        switch statusTwo {
                                        case .success:
                                            chaptersViewModel.isUserLoggedIn = true
                                        case .failure:
                                            loginViewModel.attemptingLogin = false
                                            loginViewModel.isLoading = false
                                        }
                                        
                                        loginViewModel.showLoginSpinner = false
                                    }
                                    
//
                                    //email = ""
                                    //password = ""
                                case .failure:
                                    loginViewModel.attemptingLogin = false
                                    loginViewModel.isLoading = false
                                }
                            }
                        }
                    }label: {
                        ButtonLabelLarge(text: "Login", textColor: .white, backgroundColor: Color(UIColor.systemGray2))
                            .accessibilityLabel("Login")
                    }
                    .padding(.top,50)
                    .padding(.bottom,50)
                    .opacity(loginViewModel.showLoginSpinner || !monitor.isConnected ? 0.25 : 1)
                    .disabled(loginViewModel.showLoginSpinner || !monitor.isConnected)
                    
                    /// Alert for bad login
                    .alert(item: $loginViewModel.alertInfo, content: { info in
                        Alert(title: Text(info.title), message: Text(info.message))
                    })
                    .animation(.spring())
                    
                    /// Navigation link for chapters view --> is only toggled when chapters view model is
                    /// finished downloading chapters from remote db.
                    NavigationLink(destination: ChaptersView()
                                    .environmentObject(loginViewModel)
                                    .environmentObject(chaptersViewModel)
                                    .environmentObject(chapterContentViewModel)
                                    .environmentObject(userAccountViewModel)
                                    .environmentObject(leaderboardViewModel),
                                   isActive: $chaptersViewModel.isUserLoggedIn) {EmptyView()}
                    
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 20){
                        InfoLabelMedium(text:"Need an account?")
                            .accessibilityLabel("Need an account?")
                        Button{
                            /// Only let the user tap the sign up button when the user is not trying
                            /// to login.
                            if (loginViewModel.attemptingLogin == false){
                                loginViewModel.isShowingSignupView.toggle()
                            }
                        }label: {
                            ButtonLabelLarge(text: "Tap to sign up", textColor: .white, backgroundColor: Color(UIColor.systemGray2))
                                .accessibilityLabel("Tap to sign up")
                        }
                        
                        /// Navigation for signup view
                        NavigationLink(destination: SignupView()
                                        .environmentObject(loginViewModel)
                                        .environmentObject(signupViewModel)
                                        .environmentObject(chaptersViewModel)
                                        .environmentObject(chapterContentViewModel),
                                       isActive: $loginViewModel.isShowingSignupView) {EmptyView()}
                    }
                    if (!monitor.isConnected){
                        Text("Connect to the internet before attempting to login")
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                            .accessibilityLabel("Connect to the internet before attempting to login")
                    }
                    Spacer()
                    
                    
                    VStack(spacing: 20){
                        
                    ///password recovery button
                        Button{
                            print("Button pressed")
                            passwordRecoveryViewModel.toggleNow.toggle()
                        }label: {
                            ButtonLabelLarge(text: "Forgot Password?", textColor: .white, backgroundColor: Color(UIColor.systemGray2))
                        }
                            NavigationLink(destination: PasswordRecoveryView()
                                        .environmentObject(loginViewModel)
                                        .environmentObject(signupViewModel)
                                        .environmentObject(chaptersViewModel)
                                        .environmentObject(chapterContentViewModel)
                                        .environmentObject(passwordRecoveryViewModel),
                                           isActive: $passwordRecoveryViewModel.toggleNow) {EmptyView()}
                    }
                }
                .padding(.bottom, 250)
                
                if (loginViewModel.showLoginSpinner == true){
                    ZStack {
                        Color.blackCustom
                        VStack{
                            ProgressView {
                                SpinnerInfoLabel(text: chaptersViewModel.loadingInfo)
                            }
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                    }
                    .frame(width: 175, height: 125)
                    .cornerRadius(15)
                    .animation(.spring())
                }
            }
            .animation(.spring())
            
            .onAppear {
                
                email = ""
                password = ""
                chaptersViewModel.isUserLoggedIn = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + (chaptersViewModel.logoutIntent ? 3 : 0)) {
                    
                    chaptersViewModel.logoutIntent = false
                    chaptersViewModel.chaptersArr.removeAll()
                    chaptersViewModel.clearAllData()
                    
                    chaptersViewModel.downloadChapters(completion: { status in
                        switch status {
                        case .success:
                            chaptersViewModel.organizeChaptersByNumber {
                                chaptersViewModel.retrieveUserbaseCompletion { _ in
                                }
                            }
                        case .failure:
                            print("Failed: downloading chapter")
                        }
                    })
                }
            }
            
            // Resetting user input
            .onDisappear {
                self.email = ""
                self.password = ""
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .accentColor(.white)
    }
}

// Preview
struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
