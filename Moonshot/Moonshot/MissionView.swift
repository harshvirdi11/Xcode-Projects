//
//  MissionView.swift
//  Moonshot
//
//  Created by Harsh Virdi on 11/02/26.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

struct MissionView: View {
    struct CrewMember{
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView{
            VStack{
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal){ width, axis in
                        return width * 0.6
                    }
                
                
                VStack(alignment: .leading){
                    CustomDivider()
                    
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text(mission.description)
                    
                    CustomDivider()
                    
                    Text("Crew")
                        .font(.title.bold())
                }
                .padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(crew, id: \.role){ crewMember in
                            NavigationLink{
                                DescriptionView(astronaut: crewMember.astronaut)
                            } label: {
                                HStack{
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 104, height: 72)
                                        .clipShape(.capsule)
                                        .overlay(
                                            Capsule()
                                            .stroke(.white, lineWidth: 1.0)
                                        )
                                    VStack(alignment: .leading){
                                        Text(crewMember.astronaut.name)
                                            .foregroundStyle(.white)
                                            .font(Font.subheadline.bold())
                                        
                                        Text(crewMember.role)
                                            .foregroundStyle(.white.opacity(0.5))
                                            .font(Font.subheadline)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]){
        self.mission = mission
        self.crew = mission.crew.map{
            member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else{
                fatalError("Missing Astronaut: \(member.name)")
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
