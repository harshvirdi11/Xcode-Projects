//
//  AppointmentListView.swift
//  MediCare
//
//  Created by Harsh Virdi on 09/05/26.
//

import SwiftUI
import SwiftData

struct AppointmentListView: View {
    @Query(sort: [SortDescriptor(\Appointment.date)]) var appointments: [Appointment]
    var body: some View {
        NavigationStack {
            List {
                ForEach(appointments) { appointment in
                    VStack{
                        Text(appointment.date, style: .date)
                            .font(.headline)
                        Text(appointment.status)
                            .font(.caption2)
                            .bold()
                        Text(appointment.doctor.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    AppointmentListView()
        .modelContainer(for: Appointment.self, inMemory: true)
}
