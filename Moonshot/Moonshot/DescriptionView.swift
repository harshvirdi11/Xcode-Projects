//
//  DescriptionView.swift
//  Moonshot
//
//  Created by Harsh Virdi on 11/02/26.
//

import SwiftUI

struct DescriptionView: View {
    let astronaut: Astronaut
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 70))
                    .padding(.vertical)
                
                CustomDivider()
                
                Text(astronaut.name)
                    .font(.largeTitle)
                    .padding(.bottom)
            
                Text(astronaut.description)
                    .font(.body)
                
            }
            .padding(.horizontal)
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let test = astronauts["grissom"]
    DescriptionView(astronaut: test!)
        .preferredColorScheme(.dark)
}
