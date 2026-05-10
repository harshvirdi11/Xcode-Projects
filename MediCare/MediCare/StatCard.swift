//
//  StatCard.swift
//  MediCare
//
//  Created by Harsh Virdi on 10/05/26.
//

import Foundation
import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                Spacer()
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color) // Tint the number to match
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        // Instead of white, use a 10% opacity of the accent color
        .background(color.opacity(0.1))
        .cornerRadius(15)
    }
}
