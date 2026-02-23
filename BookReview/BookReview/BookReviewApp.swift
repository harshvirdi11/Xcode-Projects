//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Harsh Virdi on 20/02/26.
//
import SwiftData
import SwiftUI

@main
struct BookReviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
