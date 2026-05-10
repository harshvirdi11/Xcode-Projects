//
//  ContentView.swift
//  MediCare
//
//  Created by Harsh Virdi on 08/05/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            MedicineListView()
                .tabItem {
                    Label("Medicines", systemImage: "pill")
                }
        }
    }
}

#Preview {
    ContentView()
}
