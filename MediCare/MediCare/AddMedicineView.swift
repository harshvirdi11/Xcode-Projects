//
//  AddMedicineView.swift
//  MediCare
//
//  Created by Harsh Virdi on 08/05/26.
//

import SwiftUI
import SwiftData

struct AddMedicineView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var remaining: Int = 0
    @State private var frequency: String = ""
    var isFormValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDosage = dosage.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFrequency = frequency.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !trimmedName.isEmpty && !trimmedDosage.isEmpty && !trimmedFrequency.isEmpty
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section() {
                    TextField("Name", text: $name)
                    TextField("Dosage", text: $dosage)
                    TextField("Frequency", text: $frequency)
                    Stepper("remaining: \(remaining)", value: $remaining, in: 0...100)
                }
            }
            .navigationTitle(Text("Add Medicine"))
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        let medicine = Medicine(name: name, dosage: dosage, frequency: frequency, remaining: remaining, total: 30, refillDate: Date.now, category: "General", times: ["3AM", "6PM"],
                        icon: "💊")
                        modelContext.insert(medicine)
                        dismiss()
                    } label: {
                        Text("Add")
                            .foregroundColor(.blue)
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

#Preview {
    AddMedicineView()
        .modelContainer(for: Medicine.self, inMemory: true)
}
