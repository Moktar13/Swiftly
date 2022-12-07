//  INFO49635 - CAPSTONE FALL 2022
//  UserAccountView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct UserAccountView: View {
    
    @EnvironmentObject var userAccountViewModel: UserAccountViewModel /// view model for this view
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack{
                    
                    HStack {
                        
                        Button{
                            chaptersViewModel.isShowingAccountView.toggle()
                        }label:{
                            UserAccountNavBarIcon(iconName: "chevron.backward")
                                .accessibilityLabel("Back Button")
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                        
                        Button{
                            userAccountViewModel.retrieveAccountinfo()
                            userAccountViewModel.isEditingAccount.toggle()
                        }label:{
                            UserAccountNavBarIcon(iconName: "gearshape")
                                .accessibilityLabel("Edit Account Button")
                        }
                        .padding(.trailing, 30)
                    }
                    .padding(.top, geometry.size.width/16)
                    .padding(.bottom, geometry.size.width/16)
                    
                    Spacer()
                    
                    HStack{
                        
                        VStack(alignment: .leading, spacing: geometry.size.width/20){
                            
                            UserAccountTitleLabel(text: "About Me")
                                .accessibilityLabel("About Me")
                            
                            VStack(alignment: .leading){
                                InfoHeader(text: "Username")
                                    .accessibilityLabel("Username")
                                InfoLabel(text: userAccountViewModel.loggedInUser.username)
                                    .accessibilityLabel(userAccountViewModel.loggedInUser.username)
                            }
                            
                            VStack(alignment: .leading){
                                InfoHeader(text: "Name")
                                    .accessibilityLabel("Name")
                                InfoLabel(text: "\(userAccountViewModel.loggedInUser.firstName) \(userAccountViewModel.loggedInUser.lastName)")
                                    .accessibilityLabel("\(userAccountViewModel.loggedInUser.firstName) \(userAccountViewModel.loggedInUser.lastName)")
                            }
                            
                            VStack(alignment: .leading){
                                InfoHeader(text: "Country")
                                    .accessibilityLabel("Country")
                                InfoLabel(text: userAccountViewModel.loggedInUser.country)
                                    .accessibilityLabel(userAccountViewModel.loggedInUser.country)
                            }
                            
                            VStack(alignment: .leading){
                                InfoHeader(text: "Date of Birth")
                                    .accessibilityLabel("Date of Birth")
                                InfoLabel(text: userAccountViewModel.loggedInUser.dob)
                                    .accessibilityLabel(userAccountViewModel.loggedInUser.dob)
                            }
                            
                            VStack(alignment: .leading){
                                InfoHeader(text: "Email Address")
                                    .accessibilityLabel("Email Address")
                                InfoLabel(text: userAccountViewModel.loggedInUser.email)
                                    .accessibilityLabel(userAccountViewModel.loggedInUser.email)
                            }
                            
                            /*
                            VStack(alignment: .leading){
                                InfoHeader(text:"Password")
                                InfoLabel(text: userAccountViewModel.loggedInUser.password)
                            }
                             */
                            
                            Button{
                                
                                /// Logging user out
                                userAccountViewModel.logoutUser()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    
                                    if (userAccountViewModel.logoutSuccessful){
                                        chaptersViewModel.isShowingAccountView = false
                                        chaptersViewModel.logoutIntent = true
                                       
                                    }
                                    else{
                                        print("login view model's loggedInEmail has not been reset")
                                    }
                                }
                                
                            }label: {
                                LogoutLabel(text: "Logout")
                                    .frame(width: 200, height: 75)
                                    .background(Color.redCustom)
                                    .cornerRadius(20)
                                    .accessibilityLabel("Logout Button")
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width/2, height: geometry.size.height/1.15, alignment: .leading)
                        .padding(.leading, geometry.size.width/24)
                        
                        Spacer()
                        
                        ZStack(alignment: .leading){
                            
                            Color(UIColor.systemGray6)
                           
                            VStack(alignment: .leading, spacing: geometry.size.width/20){
                                
                                UserAccountTitleLabel(text: "Progress")
                                    .padding(.top, -geometry.size.width/108)
                                    .padding(.leading, geometry.size.width/24)
                                    .accessibilityLabel("Progress")
                                 
                                VStack(alignment: .leading){
                                    StatHeader(text: "Chapters Completed")
                                        .padding(.bottom, geometry.size.width/48)
                                        .accessibilityLabel("Chapters Completed")
                                    ProgressBar(progress: $userAccountViewModel.chapterCompletionProgress, color: Color(UIColor.systemGreen))
                                                        .frame(width: 120, height: 120)
                                                        .padding(.leading, geometry.size.width/12)
                                }
                                .padding(.leading, geometry.size.width/24)
                                .padding(.bottom, geometry.size.width/48)
                                .frame(width: geometry.size.width/2, alignment: .leading)
                                
                                VStack(alignment: .leading){
                                    StatHeader(text: "Chapters In-Progress")
                                        .padding(.bottom, geometry.size.width/48)
                                        .accessibilityLabel("Chapters In-Progress")
                                    ProgressBar(progress: $userAccountViewModel.chapterInProgressProgress, color: Color(UIColor.systemOrange))
                                                        .frame(width: 120, height: 120)
                                                        .padding(.leading, geometry.size.width/12)
                                }
                                .padding(.leading, geometry.size.width/24)
                                .padding(.bottom, geometry.size.width/48)
                                .frame(width: geometry.size.width/2, alignment: .leading)
                                
                                VStack(alignment: .leading){
                                    StatHeader(text: "Questions Completed")
                                        .padding(.bottom, geometry.size.width/48)
                                        .accessibilityLabel("Questions Completed")
                                    ProgressBar(progress: $userAccountViewModel.questionCompletedProgress, color: Color(UIColor.systemBlue))
                                                        .frame(width: 120, height: 120)
                                                        .padding(.leading, geometry.size.width/12)
                                }
                                .padding(.leading, geometry.size.width/24)
                                .padding(.bottom, geometry.size.width/48)
                                .frame(width: geometry.size.width/2, alignment: .leading)
                                
                                Spacer()
                            }
                            
                        }.frame(width: geometry.size.width/2, height: geometry.size.height/1.25, alignment: .leading)
                            .cornerRadius(40)
                            .padding(.trailing, -geometry.size.width/24)
                            .padding(.top, -geometry.size.width/12)
                    }
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height/1.15)
            }
            
            /// Navigation link for edit account page
            NavigationLink(destination: EditAccountView()
                            .environmentObject(userAccountViewModel),
                           isActive: $userAccountViewModel.isEditingAccount) {EmptyView()}
        }
        .navigationBarHidden(true)
    }
}

struct UserAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UserAccountView()
    }
}


// Struct representing the title label
struct UserAccountTitleLabel: View {
    
    var text: String

    
    var body: some View {
        
        Text(text)
            .font(.system(size: 75,
                          weight: .medium, design: .default))
    }
}


// Struct for the info header
struct InfoHeader: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 28))
    }
}

// Struct for the info header
struct StatHeader: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 28))
    }
}

// Struct for the info label
struct InfoLabel: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 35, weight: .semibold))
    }
}


struct InfoLabelBlack: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 35, weight: .semibold))
            .foregroundColor(Color.blackCustom)
    }
}

// Struct for custom nav bar icon
struct UserAccountNavBarIcon: View {
    
    var iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .foregroundColor(Color(UIColor.systemGray2))
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
    }
}

// Struct for the info label
struct LogoutLabel: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 35, weight: .medium))
            .foregroundColor(Color.white)
    }
}
