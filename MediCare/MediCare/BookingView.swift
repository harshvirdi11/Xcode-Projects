//
//  BookingView.swift
//  MediCare
//
//  Created by Harsh Virdi on 09/05/26.
//

import SwiftUI
import SwiftData

struct BookingView: View {
    @Environment(\.modelContext) var modelcontext
    @Environment(\.dismiss) var dismiss
    
    let doctor: Doctor
    @State private var date: Date = Date()
    
    var body: some View {
            VStack {
                DatePicker("Select Date", selection: $date, displayedComponents: .date)
                    .padding()
                
                Button {
                    let appointment = Appointment( date: date, status: "Confirmed", doctor: doctor)
                    modelcontext.insert(appointment)
                    dismiss()
                } label: {
                    Text("Confirm Booking")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle(doctor.name)
    }
}

#Preview {
    BookingView(doctor: Doctor.example)
}
