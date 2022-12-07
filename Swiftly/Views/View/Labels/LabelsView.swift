//  INFO49635 - CAPSTONE FALL 2022
//  Labels.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

/// Label 1: TitleLabel
/// Description: Largest label in app, used for things like main titles.
struct TitleLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 75, weight: .light))
    }
}

/// Label 2: ButtonLabelLarge
/// Description: Largest button label, used for sign up button, login button, etc.
struct ButtonLabelLarge: View {
    var text: String
    var textColor: Color
    var backgroundColor: Color
    var body: some View {
        Text(text)
            .font(.system(size: 35, weight: .semibold))
            .padding()
            .frame(width: 400, height: 75)
            .background(Color(UIColor.systemGray))
            .cornerRadius(15)
    }
}

/// Label 3: InfoLabelMedium
/// Description: Used for displaying medium-sized labels
struct InfoLabelMedium: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 25, weight: .light))
    }
}

/// Label 4: SpinnerInfoLabel
/// Description: Used for representing text in a progress (spinner) view
struct SpinnerInfoLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(Color.whiteCustom)
            .font(.system(size: 20))
    }
}


/// Label 5: ButtonLabelSmall
/// Description: Used throughout app for smaller button labels
struct ButtonLabelSmall: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 25))
            .fontWeight(.semibold)
            .padding()
            .frame(width: 250, height: 75)
            .background(Color.blackCustom)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.trailing, 30)
    }
}


/// Label 6: MultipleSelectionRow
/// Description: Used for the MCQ part of the playground section
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        
                        if self.isSelected {
                            Image(systemName: "largecircle.fill.circle")
                                .frame(width: 44, height: 44)
                                .padding(.leading, 10)
                        }else{
                            Image(systemName: "circle")
                                .frame(width: 44, height: 44)
                                .padding(.leading, 10)
                        }
                        
                        
                    
                        
                        Button(action: self.action) {
                    
                            Text(self.title)
                                .font(.system(size: 25))
                                .padding(.leading, 10)
                                .frame(width: UIScreen.screenWidth/1.5, height: 75, alignment: .leading)
                                .cornerRadius(15)
                                .foregroundColor(colorScheme == .dark ? Color.white: Color.black)
                                .minimumScaleFactor(0.5)
                                    
                            
                            
   
                        }
                        
                    }
                }
            }.frame(width: UIScreen.screenWidth/1.25, height: 75, alignment: .leading)
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2))
        }
    }
}

/// Label 7: InteractiveSubTitle
/// Description: Used in the interactive section
struct InteractiveSubTitle: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 35, weight: .medium))
            
    }
}


/// Label 8: InteractiveContentText
/// Description: Used in interactive section
struct InteractiveContentText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 25))
            .minimumScaleFactor(0.5)
    }
}

/// Label 9: InteractiveContentText
/// Description: Used in playground preview
struct InteractiveContentTextPreview: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 28))
            .minimumScaleFactor(0.5)
    }
}

/// Label 10: InteractiveSubTitlePreview
/// Description: Used in the playground preview
struct InteractiveSubTitlePreview: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 35, weight: .medium))
    }
}




/// Label 13: LeaderboardTableHeader
/// Description: Used in the leaderboard view for the table header
struct LeaderboardTableHeader: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color.blackCustom)
    }
}

/// Label 14: LeaderboardSubTitle
/// Description: Subtitle label used in the leaderboard page
struct LeaderboardSubTitle: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 30, weight: .light))
    }
}


/// Label 15: ButtonLabelLarge
/// Description: Largest button label, used for sign up button, login button, etc.
struct NextChaptButton: View {
    var text: String
    var textColor: Color
    var backgroundColor: Color
    var body: some View {
        Text(text)
            .font(.system(size: 35, weight: .semibold))
            .padding()
            .frame(width: 400, height: 75)
            .background(backgroundColor)
            .cornerRadius(15)
    }
}


/// Label 16: Leaderboard Entry  Label
/// Description: Largest button label, used for sign up button, login button, etc.
struct LeaderboardEntryLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(Color.black)
    }
}
