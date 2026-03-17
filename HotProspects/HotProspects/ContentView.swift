//
//  ContentView.swift
//  HotProspects
//
//  Created by Harsh Virdi on 09/03/26.
//

import SwiftUI

enum SortTypes: String, CaseIterable {
    case name = "Sort by Name"
    case recent = "Sort by Date"
}

struct ContentView: View {
    @State var sortType = SortTypes.name
    
    var body: some View {
        TabView{
            ProspectsView(filter: .none, sortType: $sortType)
                .tabItem{
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted, sortType: $sortType)
                .tabItem{
                    Label("Contacted", systemImage: "checkmark")
                }
            
            ProspectsView(filter: .uncontacted, sortType: $sortType)
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
