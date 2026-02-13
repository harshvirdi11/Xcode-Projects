//
//  NavWithObservable.swift
//  Navigation
//
//  Created by Harsh Virdi on 13/02/26.
//

import SwiftUI
import Observation

@Observable
class NavigationManager {
    var path: [Int] = []
    
    func reset(){
        path.removeAll()
    }
    
}

struct ObservableDetailView: View {
    var number: Int
    var navManager: NavigationManager
    var body: some View {
        Text("showing view \(number)")
        NavigationLink("Go to next view", value: Int.random(in: 0..<100))
            .navigationTitle(Text("\(number)"))
            .toolbar{
                Button("Go to root"){
                    navManager.reset()
                }
            }
    }
}

struct NavWithObservable: View {
    @State var navManager = NavigationManager()

    var body: some View {
        NavigationStack(path: $navManager.path) {
           ObservableDetailView(number: 0, navManager: navManager)
                .navigationDestination(for: Int.self){
                    number in
                    ObservableDetailView(number: number, navManager: navManager)
                }
        }
    }
}

#Preview {
    NavWithObservable()
}
