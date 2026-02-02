//
//  ContentView.swift
//  Animated-2
//
//  Created by Harsh Virdi on 02/02/26.
//

import SwiftUI



struct ContentView: View {
    
    let snake = Array("Long Snake sssssss")
    @State private var dragAmount: CGSize = .zero
    @State private var enabled: Bool = false
    @State private var snakeColor: Color = .blue
    let possibleColors: [Color] = [.indigo, .mint, .cyan, .teal, .pink, .purple, .orange]
    
    var body: some View {
        ZStack{
            
            LinearGradient(colors: [.yellow,.red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .opacity(0.8)
            VStack{
                VStack(spacing: 5) {
                    Text("🐍 Snakey")
                        .font(.system(size: 40, weight:
                        .black, design: .rounded))
                        .foregroundStyle(.primary)
                                    
                    Text("Drag the snake to wiggle it!")
                        .font(.title3.bold())
                        .foregroundStyle(.secondary)
                    }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 20)
                .padding(.top, 60)
                   
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(0..<snake.count, id: \.self) { num in
                        Text(String(snake[num]))
                            .foregroundStyle(.white)
                            .font(.title2)
                            /*.padding([.leading, .trailing], 4)
                            .padding([.top, .bottom], 2)
                             */
                            .frame(width: 20, height: 35)
                            .background(snakeColor.gradient)
                            .cornerRadius(5)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 4)
                            .offset(dragAmount)
                            .animation(.linear.delay(Double(num)/20.0), value: dragAmount)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged{dragAmount = $0.translation}
                        .onEnded { _ in dragAmount = .zero
                            snakeColor = possibleColors.randomElement() ?? .blue
                        }
                    
                )
                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
