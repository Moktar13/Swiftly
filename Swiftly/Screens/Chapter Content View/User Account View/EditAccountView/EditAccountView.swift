//  INFO49635 - CAPSTONE FALL 2021
//  EditAccountView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct EditAccountView: View {
    
    /// Todo: Change to @Published and move it into the viewmodel
    @State var user = MockData.sampleUser
    
    @EnvironmentObject var userAccountViewModel: UserAccountViewModel /// view model for this view
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            ZStack {
                
                // Background
                Color.darkGrayCustom
                    .ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Button{
                            userAccountViewModel.isEditingAccount.toggle()
                        }label:{
                            NavBarIcon(iconName: "xmark")
                        }
                        .padding(.leading, 30)

                        Spacer()
                    }
                    .padding(.top, geometry.size.width/24)
                    .padding(.bottom, geometry.size.width/24)
                    
                    // Title
                    Text("Edit Account")
                        .font(.system(size: 75))
                        .foregroundColor(.white)
                        .padding(.bottom, geometry.size.width/42)
                    
                    // Username
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text:"Username")
                            .padding(.bottom, -geometry.size.width/120)
                    
                        TextField("",text: $user.username)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color.white)
                            .foregroundColor(.darkGrayCustom)
                            .cornerRadius(15)
                    }
                    .padding(geometry.size.width/42)
                         
                    
                    // First and last name
                    HStack(spacing:geometry.size.width/18){
                        
                        VStack(alignment: .leading){
                           
                            InputFieldLabel(text:"First Name")
                                .padding(.bottom, -geometry.size.width/120)
                            
                            
                            TextField("First Name", text : $user.firstName)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color.white)
                                .foregroundColor(.darkGrayCustom)
                                .cornerRadius(15)
                        }
                        
                        VStack(alignment: .leading) {
                           
                            InputFieldLabel(text:"Last Name")
                                .padding(.bottom, -geometry.size.width/120)

                            TextField("Last Name", text : $user.lastName)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color.white)
                                .foregroundColor(.darkGrayCustom)
                                .cornerRadius(15)
                        }
                    }.padding(geometry.size.width/42)
                    
                    // Country and DOB
                    HStack(spacing:geometry.size.width/18){
                        
                        VStack(alignment: .leading){
                            
                            InputFieldLabel(text:"Country")
                                .padding(.bottom, -geometry.size.width/120)
                            
                            TextField("Country", text : $user.country)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color.white)
                                .foregroundColor(.darkGrayCustom)
                                .cornerRadius(15)
                        }
                        
                        VStack(alignment: .leading) {
                            
                            InputFieldLabel(text:"Date of Birth")
                                .padding(.bottom, -geometry.size.width/120)
                            
                            TextField("Date of Birth", text : $user.dob)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: geometry.size.width/2 - 100, height: geometry.size.width/12)
                                .background(Color.white)
                                .foregroundColor(.darkGrayCustom)
                                .cornerRadius(15)
                        }
                    }
                    .padding(geometry.size.width/42)
                    
                    // Email Address
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text:"Email Address")
                            .padding(.bottom, -geometry.size.width/120)
                        
                        TextField("Email", text : $user.email)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color.white)
                            .opacity(0.75)
                            .foregroundColor(.darkGrayCustom)
                            .cornerRadius(15)
                            .disabled(true)
                        
                    }
                    .padding(geometry.size.width/42)
                    
                    // Password
                    VStack(alignment: .leading){
                        
                        InputFieldLabel(text:"Password")
                            .padding(.bottom, -geometry.size.width/120)
                        
                        TextField("Password", text : $user.password)
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: geometry.size.width - 150, height: geometry.size.width/12)
                            .background(Color.white)
                            .foregroundColor(.darkGrayCustom)
                            .cornerRadius(15)
                        
                    }
                    .padding(geometry.size.width/42)
                    
                    
                    // Create account button
                    Button{
                        /// Todo: Add check for valid input fields
                        /// Todo: Call method in view model that updates user changes
                        userAccountViewModel.isEditingAccount.toggle()
                    }label:{
                        ButtonLabelLarge(text: "Save Changes", textColor: .white, backgroundColor: Color.blackCustom)
                            .padding(geometry.size.width/42)
                    }
                    
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView()
    }
}
