//
//  LiquidBackground.swift
//  BookReview
//
//  Created by Harsh Virdi on 23/02/26.
//

import Foundation
import SwiftUI

struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color(red: 20/255, green: 20/255, blue: 35/255)
            
            // Blob 1: Cyan/Blue
            Circle()
                .fill(Color(red: 0/255, green: 122/255, blue: 255/255))
                .frame(width: 350, height: 350)
                .blur(radius: 90)
                .offset(x: animate ? -100 : 100, y: animate ? -100 : 20)
                .opacity(0.6)
            
            // Blob 2: Purple/Pink
            Circle()
                .fill(Color(red: 175/255, green: 82/255, blue: 222/255))
                .frame(width: 350, height: 350)
                .blur(radius: 90)
                .offset(x: animate ? 100 : -50, y: animate ? 100 : -100)
                .opacity(0.6)
            
            // Blob 3: Indigo Accent
            Circle()
                .fill(Color(red: 88/255, green: 86/255, blue: 214/255))
                .frame(width: 300, height: 300)
                .blur(radius: 90)
                .offset(x: animate ? -50 : 50, y: animate ? 50 : -50)
                .opacity(0.5)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .easeInOut(duration: 7)
                .repeatForever(autoreverses: true)
            ) {
                animate.toggle()
            }
        }
    }
}
