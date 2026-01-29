//
//  BookView.swift
//  BookClub
//
//  Created by Harsh Virdi on 14/01/26.
//

import SwiftUI

struct EditorConfig {
    var isEditorPresented = false
    var note = ""
    var progress: Double = 0
    
    // This function handles the logic of opening the editor
        mutating func present(initialProgress: Double) {
            progress = initialProgress
            note = ""
            isEditorPresented = true
        }
}

struct BookView: View {
    //@State private var editorConfig = EditorConfig()
    //let book = Book(title: "SwiftUI Essentials", author: "Apple", coverName: "book.fill")
    @StateObject var currentlyReading = CurrentlyReading(
            book: Book(title: "StateObject Power", author: "Apple", coverName: "book.fill"),
            initialProgress: 0.0)
    var body: some View {
        VStack{
            BookCard(book: currentlyReading.book, progress: currentlyReading.progress)
            Button(action:{currentlyReading.progress+=0.1})
            {
                Label("Update Progress", systemImage: "square.and.pencil")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    BookView()
}
