//
//  ContentView.swift
//  Transitions
//
//  Created by Harsh Virdi on 03/02/26.
//

import SwiftUI


struct CornerRotateModifier: ViewModifier{
    var angle: Double
    var anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(angle), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition{
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(angle: 90, anchor: .topLeading), identity: CornerRotateModifier(angle: 0, anchor: .topLeading))
    }
}

struct ContentView: View {
    @State private var isShowingRed: Bool = true
    @State private var isShowingYellow: Bool = false

    var body: some View {
        VStack {
            Button{
                withAnimation{
                    isShowingRed.toggle()
                }
            } label: {
                Text("Show Model")
            }
            
            if isShowingRed {
                Rectangle()
                .fill(Color.red)
                .frame(width: 200, height: 200)
                .transition(AsymmetricTransition(insertion: .scale, removal: .opacity))
            }
            
            ZStack{
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 200, height: 200)
                
                if isShowingYellow{
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 200, height: 200)
                        .transition(.pivot)
                        .zIndex(1)
                }
                
                else{
                    
                }
            }
            .onTapGesture {
                withAnimation{
                    isShowingYellow.toggle()
                }
            }
        }
        
        .padding()
    }
}

#Preview {
    ContentView()
}
