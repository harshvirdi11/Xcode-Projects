//
//  BookCard.swift
//  BookClub
//
//  Created by Harsh Virdi on 14/01/26.
//

import SwiftUI

struct Book{
    let title: String
    let author: String
    let coverName: String
}

struct RingProgressView: View {
    var value: Double // 0.0 to 1.0
    
    var body: some View {
        ZStack {
            // Background grey circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 4)
            // Foreground blue circle
            Circle()
                .trim(from: 0, to: CGFloat(value))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90)) // Start from top
        }
        .frame(width: 40, height: 40)
    }
}

struct BookCard: View {
    let book: Book
    let progress: Double
    
    var body: some View {
        HStack{
            Image(systemName: book.coverName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 75)
                .foregroundColor(.blue) // Makes the icon blue
                .background(Color.gray.opacity(0.1))
                .cornerRadius(4)
            
            VStack(alignment: .leading){
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
            Spacer()
            RingProgressView(value: progress)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.blue.opacity(1.0), radius: 4, x: 0, y: 2)
        
    }
    
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground) // Light grey background
        var myBook = Book(title: "SwiftUI Essentials", author: "Apple", coverName: "book.fill")
    
        BookCard(
            book : myBook,
            progress: 0.65
        )
        .padding()
    }
}
