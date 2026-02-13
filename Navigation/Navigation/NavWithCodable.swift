//
//  NavWithCodable.swift
//  Navigation
//
//  Created by Harsh Virdi on 13/02/26.
//

import SwiftUI
import Observation

@Observable
class PathStore {
    
    var path: [Int]{
        didSet{
            save()
        }
    }
    
    let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    func save(){
        do{
            let data = try JSONEncoder().encode(path)
            try data.write(to: savePath)
        }
        catch{
            print("Couldn't save path")
        }
    }
    
    init(){
        
        guard let data = try? Data(contentsOf: savePath)
        else{
            path = []
            return
        }
        
       guard let decoded = try? JSONDecoder().decode([Int].self, from: data) else{
           path = []
           return
       }
        path = decoded
    }
}

struct DetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}

struct NavWithCodable: View {
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i)
                }
        }
    }
}

#Preview {
    NavWithCodable()
}
