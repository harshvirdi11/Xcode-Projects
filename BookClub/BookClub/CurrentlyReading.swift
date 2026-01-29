//
//  CurrentlyReading.swift
//  BookClub
//
//  Created by Harsh Virdi on 14/01/26.
//

import SwiftUI
internal import Combine

class CurrentlyReading: ObservableObject {
    
    let book: Book
    @Published var progress: Double = 0.0
    @Published var isFinished: Bool = false
    
    init(book: Book, initialProgress: Double = 0.0) {
            self.book = book
            self.progress = initialProgress
        }
    
}

