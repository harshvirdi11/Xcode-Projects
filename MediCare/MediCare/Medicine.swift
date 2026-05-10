//
//  Medicine.swift
//  MediCare
//
//  Created by Harsh Virdi on 08/05/26.
//

import SwiftData
import Foundation

@Model
final class Medicine {
    var name: String
    var dosage: String
    var frequency: String
    var remaining: Int
    var total: Int
    var refillDate: Date
    var category: String
    var times: [String]
    var icon: String
    @Relationship(deleteRule: .cascade)
    var doseLog: [DoseLog] = []
    
    init(name: String, dosage: String, frequency: String, remaining: Int, total: Int, refillDate: Date, category: String, times: [String], icon: String) {
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.remaining = remaining
        self.total = total
        self.refillDate = refillDate
        self.category = category
        self.times = times
        self.icon = icon
    }
}

@Model
final class DoseLog {
    var date: Date
    var taken: Bool
    var medicine: Medicine
    
    init(date: Date, taken: Bool, medicine: Medicine) {
        self.date = date
        self.taken = taken
        self.medicine = medicine
    }
}
