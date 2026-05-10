//
//  MediCareApp.swift
//  MediCare
//
//  Created by Harsh Virdi on 08/05/26.
//

import SwiftUI
import SwiftData

@main
struct MediCareApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Medicine.self, DoseLog.self])
        }
    }
}
