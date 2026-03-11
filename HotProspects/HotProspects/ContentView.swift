//
//  ContentView.swift
//  HotProspects
//
//  Created by Harsh Virdi on 09/03/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            ProspectsView(filter: .none)
                .tabItem{
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem{
                    Label("Contacted", systemImage: "checkmark")
                }
            
            ProspectsView(filter: .unContacted)
                .tabItem{
                    Label("Not Contacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem{
                    Label("Me", systemImage: "person.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
