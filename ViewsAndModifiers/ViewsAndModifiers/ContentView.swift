//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Harsh Virdi on 26/01/26.
//

import SwiftUI


struct BigBlue: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View {
    func bigblue() -> some View{
        modifier(BigBlue())
    }
}

/*
 struct BigBlue: View{
    var text: String
    var body: some View{
        Text(text)
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}
 */

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Hello, World!")
                
        }
        .bigblue()
        //.bigBlue()
        }
}

#Preview {
    ContentView()
}

