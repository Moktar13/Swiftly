//  INFO49635 - CAPSTONE FALL 2022
//  LeaderboardView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct LeaderboardView: View {
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor(Color.white)
    }
    
    /// Environment variables
    @EnvironmentObject var leaderboardViewModel: LeaderboardViewModel /// --> view model for this view
    @EnvironmentObject var chaptersViewModel: ChaptersViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    HStack {
                        Button{
                            chaptersViewModel.isShowingLeaderboardView.toggle()
                        }label:{
                            NavBarIcon(iconName: "chevron.backward")
                        }
                        .padding(.leading, 30)
                        Spacer()
                    }
                    .padding(.top, geometry.size.width/16)
                    
                    
                    TitleLabel(text:"Leaderboard")
                        .padding(.leading, geometry.size.width/24)
                        .foregroundColor(colorScheme == .dark ? Color.white: Color.black)
                    
                    LeaderboardSubTitle(text:"Swiftly Userbase Progress")
                        .foregroundColor(colorScheme == .dark ? Color.white: Color.black)
                        .padding(.leading,  geometry.size.width/24)
                    
                    HStack {
                        InputFieldLabel(text: "Filter by:")
                            .padding(.bottom, geometry.size.width/122)
                            .accessibilityLabel("Filter By Picker")
                    
                        Picker("", selection: $leaderboardViewModel.selectedFilter) {
                            ForEach(leaderboardViewModel.chapterFilters, id: \.self) {
                                Text($0)
                                    .font(.system(size: 25))
                            }
                        }
                        .frame(width: 100, height: 40)
                        .background(Color(UIColor.systemGray3))
                        .cornerRadius(10)
                        .accentColor(colorScheme == .dark ? Color.white: Color.black)
                        
                        Picker("", selection: $leaderboardViewModel.selectedCountryFilter) {
                            ForEach(leaderboardViewModel.countryFilters, id: \.self) {
                                Text($0)
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.black)
                            }
                        }
                        .frame(width: 100, height: 40)
                        .background(Color(UIColor.systemGray3))
                        .cornerRadius(10)
                        .accentColor(colorScheme == .dark ? Color.white: Color.black)
                        
                        
                        Button{
                            leaderboardViewModel.startDataRetrieval(filterOne: leaderboardViewModel.selectedFilter == "None" ? nil :
                                                                        leaderboardViewModel.selectedFilter,
                                                                    filterTwo: leaderboardViewModel.selectedCountryFilter == "None" ? nil : leaderboardViewModel.selectedCountryFilter)
                            leaderboardViewModel.isDataLoading = true
                        } label: {
                            Text("Apply")
                                .font(.system(size: 20, weight: .regular, design: .default))
                                .foregroundColor(Color(UIColor.white))
                                .frame(width: 100, height: 40)
                                .accessibilityLabel("Apply Filter Button")
                                .background(Color.blueCustom)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.leading,  geometry.size.width/22)
                    
                    
                    VStack {
                        ZStack {
                            
                            Color.white
                            
                            VStack {
                                HStack(spacing: geometry.size.width/8){
                                    LeaderboardTableHeader(text: "Username")
                                        .padding(.trailing, 20)
                                    LeaderboardTableHeader(text: "Country")
                                    LeaderboardTableHeader(text: "Total Score")
                                        .padding(.leading, 15)
                                }
                                .frame(width: geometry.size.width/1.10)
                                .padding(.top, 25)
                                Spacer()
                                
                                List {
                                    
                                    ForEach(leaderboardViewModel.userLeaderboardData, id: \.id) { user in

                                        let formattedFloat = String(format: "%.1f", user.totalScore)
                                        
                                        HStack(){
                                            LeaderboardEntryLabel(text: "\(user.username)")
                                                .frame(width: geometry.size.width/4, height: 30, alignment: .center)
                                            LeaderboardEntryLabel(text: leaderboardViewModel.getCountryFlag(country: user.country))
                                                .frame(width: geometry.size.width/4, height: 30, alignment: .center)
                                                .padding(.trailing, 5)
                                            LeaderboardEntryLabel(text: "\(formattedFloat)%")
                                                .frame(width: geometry.size.width/6, height: 30, alignment: .center)
                                                .padding(.trailing, geometry.size.width/8)
                                                .padding(.leading, geometry.size.width/36)
                                        }
                                        .frame(width: geometry.size.width/1.10)
                                        .cornerRadius(5)
                                        .listRowBackground(user.username == leaderboardViewModel.loggedInUser.username ? Color.lightBlueCustom : Color.clear)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width/1.10, height: geometry.size.height/1.5, alignment: .center)
                        .cornerRadius(40)
                    }
                    .frame(width: geometry.size.width)
                    .padding(.top, 15)
                }.frame(width: geometry.size.width, alignment: .leading)
                
                Spacer()
                
                if (leaderboardViewModel.isDataLoading == true){
                    
                    ZStack {
                        Color.blackCustom
                        
                        VStack{
                            ProgressView {
                                SpinnerInfoLabel(text: "Getting Data")
                            }
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                    }
                    .frame(width: 175, height: 125)
                    .cornerRadius(15)
                    .animation(.spring())
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            leaderboardViewModel.startDataRetrieval(filterOne: leaderboardViewModel.selectedFilter == "None" ? nil : leaderboardViewModel.selectedFilter)
            leaderboardViewModel.isDataLoading = true
        }
        
        .onDisappear {
            leaderboardViewModel.userLeaderboardData.removeAll()
            leaderboardViewModel.isDataLoading = false
        }
    }
}

/// Preview
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
