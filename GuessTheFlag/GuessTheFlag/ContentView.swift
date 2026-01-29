//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Harsh Virdi on 23/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore: Bool = false
    @State private var gameEnd: Bool = false
    @State private var scoreTitle: String = ""
    @State private var score: Int = 0
    @State private var question: Int = 0
    
    struct FlagImageView: View{
        var name: String
        var body: some View{
            Image(name)
                .clipShape(.capsule)
                .shadow(color: .black, radius: 5)
            
        }
    }
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 300, endRadius: 400)
            
            VStack{
                Spacer()
                Spacer()
                Text("Guess the Flag!")
                    .font(Font.title.weight(.bold))
                    .foregroundStyle(Color.white)
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap on the Flag of")
                            .foregroundStyle(Color.secondary)
                            .font(Font.subheadline.weight(.semibold))
                        Text(countries[correctAnswer])
                            .font(Font.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImageView(name: countries[number])
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                
                Text("Question: \(question)")
                    .font(Font.largeTitle.weight(.semibold))
                    .foregroundStyle(Color.white)
                Spacer()
                Text("Score: \(score)")
                    .font(Font.largeTitle.weight(.semibold))
                    .foregroundStyle(Color.white)
                Spacer()
                
            }
            .padding()
            
        }
        .ignoresSafeArea()
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue"){
                askQuestion()
            }
        } message: {
            Text("Your score is: \(score)")
        }
        
        .alert("Game Over", isPresented: $gameEnd){
            Button("Play Again"){
                score = 0
                question = 0
                askQuestion()
            }
        }
        message: {
                Text("Game over your final score is: \(score)")
            }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct!"
            score += 1
            question += 1
        }
        else{
            scoreTitle = "Wrong!"
            question += 1
        }
        if question == 10{
            gameEnd = true
        }
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
