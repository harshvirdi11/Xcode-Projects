//
//  LightLiquidBackground.swift
//  BookReview
//
//  Created by Harsh Virdi on 23/02/26.
//

import SwiftUI

struct LightLiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.white
 
            Circle()
                .fill(Color(red: 20/255, green: 150/255, blue: 255/255))
                .frame(width: 350, height: 350)
                .blur(radius: 75) // Decreased from 90 for a stronger core
                .offset(x: animate ? -100 : 100, y: animate ? -100 : 20)
                .opacity(0.8) // Cranked up from 0.45
            
            Circle()
                .fill(Color(red: 255/255, green: 50/255, blue: 150/255))
                .frame(width: 350, height: 350)
                .blur(radius: 75)
                .offset(x: animate ? 100 : -50, y: animate ? 100 : -100)
                .opacity(0.8)
            
            Circle()
                .fill(Color(red: 255/255, green: 180/255, blue: 50/255))
                .frame(width: 300, height: 300)
                .blur(radius: 75)
                .offset(x: animate ? -50 : 50, y: animate ? 50 : -50)
                .opacity(0.8)
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

#Preview {
    LightLiquidBackground()
}

