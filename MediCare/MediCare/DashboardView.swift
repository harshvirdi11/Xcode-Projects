//
//  DashboardView.swift
//  MediCare
//
//  Created by Harsh Virdi on 10/05/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(filter: #Predicate<Medicine> {$0.remaining<=5}, sort: [SortDescriptor(\Medicine.name)]) var lowStockMedicines: [Medicine]
    @Query(sort: [SortDescriptor(\Appointment.date)]) var upcomingAppointments: [Appointment]
    
    var body: some View {
        NavigationStack{
            List {
                Section("Low Stock Alerts") {
                    if (!lowStockMedicines.isEmpty) {
                        ForEach(lowStockMedicines) { medicine in
                            VStack {
                                Text(medicine.name)
                                    .font(.headline)
                                Text("\(medicine.remaining) units left")
                                    .font(Font.caption.bold())
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    else {
                        Text("No low stock medicines")
                    }
                }
                
                Section("Upcoming Appointments") {
                    if (!upcomingAppointments.isEmpty) {
                        ForEach(upcomingAppointments) { appointment in
                            VStack {
                                Text(appointment.doctor.name)
                                    .font(.headline)
                                Text(appointment.date, style: .date)
                                    .font(Font.caption.bold())
                            }
                        }
                    }
                    else {
                        Text("No upcoming appointments")
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
