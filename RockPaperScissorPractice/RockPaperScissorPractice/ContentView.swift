//
//  ContentView.swift
//  RockPaperScissorPractice
//
//  Created by Harsh Virdi on 26/01/26.
//

import SwiftUI

struct ContentView: View {
    
    let moves: [String] = ["Rock", "Paper", "Scissors"]
    let winningMoves: [String] = ["Paper", "Scissors", "Rock"]
    @State var score: Int = 0
    @State var appMove: Int = Int.random(in: 0..<3)
    let winLose: [String] = ["Lose or Draw", "Win"]
    @State var decider: Int = Int.random(in: 0..<2)
    @State var showingScore: Bool = false
    @State var scoreState: String = ""
    @State var gameEnd: Bool = false
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.white,.yellow], startPoint: .top, endPoint: .bottom)
            VStack{
                Text("Score: \(score)")
                    .fontWeight(.heavy)
                
                Text("Rock Paper Scissor")
                    .font(Font.largeTitle.bold())
                    .fontDesign(Font.Design.serif)
                    .padding()
                
                Text("Computer played ⬇️")
                    .font(Font.headline.bold())
                    .padding()
                Image(moves[appMove])
                    .clipShape(.capsule)
                VStack{
                    Text("You need to ")
                    +
                    Text(winLose[decider] + " ")
                        .foregroundStyle(decider == 1 ? .green : .red)
                    +
                    Text("Select your move:")
                }
                .frame(width: 350)
                .background(.regularMaterial)
                .clipShape(.capsule)
                
                
                HStack{
                    ForEach(moves, id: \.self){
                        move in
                        Button{
                            movePlayed(with: move)
                        } label: {
                            Image(move)
                                .clipShape(.capsule)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .alert(scoreState, isPresented: $showingScore){
            Button("Continue"){
                next()
            }
        } message: {
            Text("your score is \(score)")
        }
        
        .alert("Game Over!",isPresented: $gameEnd){
            Button("Restart"){
                score = 0
                next()
            }
        } message: {
            Text("your score was \(score)")
        }
    }
    
    func movePlayed(with move: String){
        if winLose[decider] == "Win" && move == winningMoves[appMove]{
            score += 1
            scoreState = "Nice!"
        }
        
        else if winLose[decider] == "Lose or Draw" && move != winningMoves[appMove]{
            score += 1
            scoreState = "Nice!"
        }
        
        else{
            scoreState = "Wrong you had to \(winLose[decider])!"
        }
        
        if score == 5{
            gameEnd = true
        }
        showingScore = true
    }
    
    func next(){
        appMove = Int.random(in: 0..<3)
        decider = Int.random(in: 0..<2)
    }
}

#Preview {
    ContentView()
}
