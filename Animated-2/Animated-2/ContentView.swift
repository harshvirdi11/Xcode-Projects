//
//  ContentView.swift
//  Animated-2
//
//  Created by Harsh Virdi on 02/02/26.
//

import SwiftUI



struct ContentView: View {
    
    let snake = Array("Hello World!")
    @State private var dragAmount: CGSize = .zero
    @State private var enabled: Bool = false
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<snake.count, id: \.self) { num in
                Text(String(snake[num]))
                    .font(Font.headline)
                    .background(enabled ? Color.red : Color.blue)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(num)/20.0), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged{dragAmount = $0.translation}
                .onEnded { _ in dragAmount = .zero
                    enabled.toggle()
                }
                          
            )
    }
}

#Preview {
    ContentView()
}
