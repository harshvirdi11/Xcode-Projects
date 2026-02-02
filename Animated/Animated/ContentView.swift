//
//  ContentView.swift
//  Animated
//
//  Created by Harsh Virdi on 30/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var animationEffect = 1.0
    @State private var rotNum: Double = 0.0
    @State private var enabled = true
    
    var body: some View {
        
        VStack{
            Stepper("Bouncy Button", value: $animationEffect, in: 1...10)
                .zIndex(1)
                .font(Font.largeTitle.bold())
                .padding()
            
            Button{
            } label: {
                Text("Change my size!")
            }
            .padding(55)
            .background(Color.red)
            .foregroundStyle(Color.white)
            .clipShape(.circle)
            .scaleEffect(animationEffect)
            .animation(.spring, value: animationEffect)
            
    
            Spacer()
            
            Text("Spinny Button")
                .font(Font.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Button{
                withAnimation(.spring(duration: 1.0, bounce: 0.8)){
                    rotNum += 360
                }
            } label: {
                Text("Tap me!")
            }
            .padding(55)
            .background(Color.green)
            .foregroundStyle(Color.white)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(rotNum), axis: (x: 0, y: 1, z: 0))
            
            Spacer()
            
            Text("Color Button")
                .font(Font.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Button{
                    enabled.toggle()
            } label: {
                Text("Tap me!")
            }
            .padding(55)
            .background(enabled ? Color.yellow : Color.blue)
            .foregroundStyle(Color.white)
            .animation(.default, value: enabled)
            .clipShape(.rect(cornerRadius: enabled ? 60: 0))
            .animation(.bouncy(duration: 0.5,extraBounce: 0.2), value: enabled)
            
            Spacer()
        }
    }
    
}

#Preview {
    ContentView()
}
