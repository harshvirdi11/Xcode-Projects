//
//  ContentView.swift
//  Bookworm
//
//  Created by Harsh Virdi on 20/02/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Book.title),
                  SortDescriptor(\Book.author)])
                  var books: [Book]
    @State private var showingAddScreen = false
    var body: some View {
        NavigationStack{
            List{
                ForEach(books){ book in
                    NavigationLink(value: book) {
                        HStack{
                            EmojiRatingView(rating: book.rating)
                                .font(Font.largeTitle.bold())
                            
                            VStack{
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.rating == 1 ? Color.red : book.rating > 3 ? Color.green : .primary)
                                Text(book.author)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
                .navigationTitle(Text("Bookworm"))
                .navigationDestination(for: Book.self){ book in
                    DetailView(book: book)
                }
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Add", systemImage: "plus"){
                            showingAddScreen.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen){
                    AddBookView()
                }
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        for offset in offsets{
            modelContext.delete(books[offset])
        }
    }
}

#Preview {
    ContentView()
}
