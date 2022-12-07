//  INFO49635 - CAPSTONE FALL 2022
//  ImageViews.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI

struct ImageViewLarge: View {
    
    var imageName: String
    var body: some View {
        
        Image(systemName: imageName)
            .resizable()
            .foregroundColor(.white)
            .aspectRatio(contentMode: .fit)
            .frame(width: 55, height: 55)
    }
}
