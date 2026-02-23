//
//  ContentView.swift
//  Bookworm
//
//  Created by Harsh Virdi on 20/02/26.
//

import SwiftUI
import SwiftData

enum BackgroundStyle: String, CaseIterable {
    case lightLiquid = "Light Liquid"
    case darkLiquid = "Dark Liquid"
    
    var rowBackground: Color {
            switch self {
            case .lightLiquid:
                return Color.white.opacity(0.5)
            case .darkLiquid:
                return Color.black.opacity(0.5)
            }
        }

        var colorScheme: ColorScheme {
            switch self {
            case .lightLiquid:
                return .light
            case .darkLiquid:
                return .dark
            }
        }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Book.title),
                  SortDescriptor(\Book.author)])
                  var books: [Book]
    @State private var showingAddScreen = false
    @AppStorage("selectedBackground") private var selectedBackground: BackgroundStyle = .lightLiquid
    
    var body: some View {
        
            NavigationStack{
                
                ZStack{
                    switch selectedBackground {
                    case .lightLiquid:
                        LightLiquidBackground()
                    case .darkLiquid:
                        DarkLiquidBackground()
                    }
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
                        .listRowBackground(selectedBackground.rowBackground)
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle(Text("Book Review"))
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
                        ToolbarItem{
                            Menu{
                                Picker("Background Style", selection: $selectedBackground){
                                    ForEach(BackgroundStyle.allCases, id: \.self){ style in
                                        Text(style.rawValue).tag(style)
                                    }
                                }
                            } label: {
                                Image(systemName: "paintpalette")
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddScreen){
                        AddBookView()
                    }
                }
                .preferredColorScheme(selectedBackground.colorScheme)
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
        .preferredColorScheme(.light)
}
