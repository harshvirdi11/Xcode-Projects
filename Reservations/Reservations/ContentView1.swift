//
//  MyView.swift
//  Reservations
//
//  Created by Harsh Virdi on 09/01/26.
//

import Foundation
import SwiftUI

struct ContentView1: View {
    @State var personCount: Int = 1
    
    var body: some View {
        VStack {
            
            Text("Little Lemon")
            Text("Reservations")
            Text("Reservation for: \(personCount)")
            Stepper {
            } onIncrement: {
                personCount += 1
            } onDecrement: {
                personCount = (personCount == 1) ? 1 : personCount - 1
            }
        }
        .padding()
    }
}
