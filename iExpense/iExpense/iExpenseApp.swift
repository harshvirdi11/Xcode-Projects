//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Harsh Virdi on 03/02/26.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
