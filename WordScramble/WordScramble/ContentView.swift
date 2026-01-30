//
//  ContentView.swift
//  WordScramble
//
//  Created by Harsh Virdi on 29/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var newWord: String = ""
    @State private var usedWords: [String] = []
    @State private var rootWord: String = ""
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingError: Bool = false
    @State private var score: Int = 0
    var body: some View {
            NavigationStack{
                List{
                    Section{
                        TextField("Enter you word", text: $newWord)
                            .textInputAutocapitalization(.never)
                        
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                    Section{
                        ForEach(usedWords, id: \.self){ word in
                            HStack{
                                Text("\(word.count)")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                    .padding(8)
                                    .background(.blue.gradient.opacity(0.8))
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                                Text(word)
                            }
                        }
                        
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                }
                .navigationTitle(rootWord)
                .scrollContentBackground(.hidden)
                .background(LinearGradient(colors: [.blue, .purple],
                                              startPoint: .topLeading,
                                              endPoint: .bottomTrailing)
                                              .ignoresSafeArea())
                .toolbar{
                    ToolbarItem(){
                        Button{
                            startGame()
                        } label: {
                            Text("New Word")
                                .foregroundStyle(.blue)
                                .fontWeight(.medium)
                        }
                    }
                    
                    ToolbarItem(placement: .principal){
                        Text("Score: \(score)")
                            .font(Font.headline.bold())
                    }
                }
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError)
                {
                    Button("OK"){}
                } message: {
                    Text(errorMessage)
                }
            }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Can't do that!", message: "Word already used!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Can't do that!", message: "Word can't be made with letters of \(rootWord)")
            return
        }
        
       guard tooShort(word: answer) else {
            wordError(title: "Can't do that!", message: "Word is too short")
           return
        }
        
        guard sameWord(word: answer) else {
            wordError(title: "Can't do that!", message: "You can't use the same word given above!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Can't do that!", message: "\(newWord) is not a real word!")
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        score += answer.count + 10
        newWord = ""
    }
    
    func startGame() {
        score = 0
        newWord = ""
        usedWords.removeAll()
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsUrl, encoding: .utf8)
            {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt")
    }
    
    func isOriginal(word: String) -> Bool{
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempword = rootWord
        for letter in word {
            if let pos = tempword.firstIndex(of: letter){
                tempword.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0 , length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func tooShort(word: String) -> Bool {
        return word.count >= 3
    }
    
    func sameWord(word: String) -> Bool {
        return word != rootWord
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
