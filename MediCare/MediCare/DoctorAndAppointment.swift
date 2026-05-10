//
//  DoctorAndAppointment.swift
//  MediCare
//
//  Created by Harsh Virdi on 09/05/26.
//

import SwiftData
import Foundation

@Model
final class Doctor: Identifiable {
    var name: String
    var specialty: String
    var fee: Int
    @Relationship(deleteRule: .cascade)
    var appointments: [Appointment] = []
    
    init(name: String, specialty: String, fee: Int) {
        self.name = name
        self.specialty = specialty
        self.fee = fee
    }
    
    static let example = Doctor(name: "Dr. John Doe", specialty: "Cardiology", fee: 200)
}

@Model
final class Appointment {
    var date: Date
    var status: String
    var doctor: Doctor
    
    init(date: Date, status: String, doctor: Doctor) {
        self.date = date
        self.status = status
        self.doctor = doctor
    }
}

