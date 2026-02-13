//
//  GridView.swift
//  Moonshot
//
//  Created by Harsh Virdi on 12/02/26.
//

import SwiftUI

struct GridView: View {
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150))
    ]
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns){
                    ForEach(missions) { mission in
                        NavigationLink(value: mission) {
                            VStack{
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                VStack{
                                    Text(mission.displayName)
                                        .font(Font.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            }
                        }
                    }
                }
                .padding([.horizontal, .bottom])
                .navigationDestination(for: Mission.self){ mission in
                    MissionView(mission: mission, astronauts: astronauts)
                }
            }
            .background(.darkBackground)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode( "missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode( "astronauts.json")
    GridView(missions: missions, astronauts: astronauts)
        .preferredColorScheme(.dark)
}
