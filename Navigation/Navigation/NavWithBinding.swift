//
//  ContentView.swift
//  Navigation
//
//  Created by Harsh Virdi on 13/02/26.
//

import SwiftUI

struct BindingDetailView: View {
    var number: Int
    @Binding var path: [Int]
    var body: some View {
        NavigationLink("showing view number \(number)", value: Int.random(in: 0..<1000))
            .navigationTitle("\(number)")
            .toolbar{
                Button("Go Back"){
                    path.removeAll()
                }
            }
    }
}

struct NavWithBinding: View {
    @State private var path = [Int]()
    var body: some View {
        NavigationStack(path: $path){
            BindingDetailView(number: 0, path: $path)
                .navigationDestination(for: Int.self) {
                    number in
                    BindingDetailView(number: number, path: $path)
                }
        }
    }
}

#Preview {
    NavWithBinding()
}
