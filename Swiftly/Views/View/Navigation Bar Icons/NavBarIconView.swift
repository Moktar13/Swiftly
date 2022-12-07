//  INFO49635 - CAPSTONE FALL 2022
//  NavBarIconView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

/// View 1: NavBarIcon
/// Description: View for the left navigation bar button
struct NavBarIcon: View {
    var iconName: String
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
            .foregroundColor(Color(UIColor.systemGray2))
    }
}

/// View 2: SpecialNavBarIcon
/// Description: Used mainly for the user account icon in chapters view
struct SpecialNavBarIcon: View {
    var text: String
    var body: some View {
        Image(systemName: text)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 44, height: 44)
            .foregroundColor(Color(UIColor.systemGray))
            .padding(.leading, 30)
    }
}
