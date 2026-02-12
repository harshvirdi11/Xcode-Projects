//
//  ContentView.swift
//  Moonshot
//
//  Created by Harsh Virdi on 08/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var layout = true
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                Text("Moonshot")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal,.bottom])
                    .background(.darkBackground)
                
                Group{
                    if layout == true{
                        GridView(missions: missions, astronauts: astronauts)
                    }
                    else{
                        ListView(missions: missions, astronauts: astronauts)
                    }
                }
                
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .toolbar{
                    Button(){
                        withAnimation(){
                            layout.toggle()
                        }
                    } label:{
                        HStack{
                            Text("Toggle View")
                            Image(systemName: layout == false ? "list.bullet" : "square.grid.2x2")
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
