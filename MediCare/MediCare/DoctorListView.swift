//
//  DoctorListView.swift
//  MediCare
//
//  Created by Harsh Virdi on 09/05/26.
//

import SwiftUI
import SwiftData

struct DoctorListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var doctors: [Doctor]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(doctors) { doctor in
                    NavigationLink {
                        BookingView(doctor: doctor)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(doctor.name)
                                .font(.headline)
                            Text(doctor.specialty) // Fixed typo here
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\(doctor.fee)")
                                .font(.caption2)
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Doctors")
            .toolbar {
                ToolbarItem {
                    Button("Dummy Add Doctor") {
                        // Prevent infinite duplicate doctors
                        if doctors.isEmpty {
                            let doc1 = Doctor(name: "Dr. Smith", specialty: "Cardiology", fee: 150)
                            let doc2 = Doctor(name: "Dr. Johnson", specialty: "Neurology", fee: 120)
                            let doc3 = Doctor(name: "Dr. Brown", specialty: "Orthopedics", fee: 130)
                            
                            modelContext.insert(doc1)
                            modelContext.insert(doc2)
                            modelContext.insert(doc3)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DoctorListView()
        // Fixed Preview crash
        .modelContainer(for: Doctor.self, inMemory: true)
}
