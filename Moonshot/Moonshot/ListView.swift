//
//  ListView.swift
//  Moonshot
//
//  Created by Harsh Virdi on 12/02/26.
//

import SwiftUI

struct ListView: View {
   
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    var body: some View {
        List{
            ForEach(missions) { mission in
                NavigationLink(value: mission) {
                    VStack {
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
                        
                        CustomDivider()
                            .padding(.vertical)
                    }
                }
                .listRowBackground(Color.darkBackground)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                
            }
            .padding([.horizontal])
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.darkBackground)
        .navigationDestination(for: Mission.self){mission in
            MissionView(mission: mission, astronauts: astronauts)
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode( "missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode( "astronauts.json")
    ListView(missions: missions, astronauts: astronauts)
        .preferredColorScheme(.dark)
}
