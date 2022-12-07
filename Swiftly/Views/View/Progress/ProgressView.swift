//  INFO49635 - CAPSTONE FALL 2022
//  Progress.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import Foundation
import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float
    
    var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}
