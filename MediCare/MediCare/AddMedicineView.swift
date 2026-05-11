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
    @State private var frequency: String = ""
    @State private var remaining: Int = 0
    @State private var selectedIcon: String = "💊"
    @State private var isShowingScanner: Bool = false
    
    let iconOptions = ["💊", "💧", "💉", "🧴", "🌿", "🍎"]
    
    var isFormValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDosage = dosage.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFrequency = frequency.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !trimmedName.isEmpty && !trimmedDosage.isEmpty && !trimmedFrequency.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Icon Picker Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Medicine Icon")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(iconOptions, id: \.self) { (icon: String) in
                                    let isSelected = selectedIcon == icon
                                    Button {
                                        selectedIcon = icon
                                    } label: {
                                        Text(icon)
                                            .font(.title)
                                            .padding(12)
                                            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                    
                    // MARK: - Details Card
                    VStack(spacing: 16) {
                        IconTextField(placeholder: "Medicine Name", text: $name, icon: "pencil")
                        
                        Button {
                            isShowingScanner = true
                        } label: {
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                Text("Scan Packaging")
                            }
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 38)
                        
                        Divider()
                        
                        IconTextField(placeholder: "Dosage (e.g., 200mg)", text: $dosage, icon: "pill.fill")
                        
                        Divider()
                        
                        IconTextField(placeholder: "Frequency (e.g., Twice a day)", text: $frequency, icon: "clock.fill")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                    
                    // MARK: - Inventory Card
                    VStack {
                        Stepper(value: $remaining, in: 0...100) {
                            HStack {
                                Image(systemName: "shippingbox.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 30)
                                Text("Current Stock: \(remaining)")
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                    
                    // MARK: - Massive Save Button
                    Button {
                        let medicine = Medicine(
                            name: name,
                            dosage: dosage,
                            frequency: frequency,
                            remaining: remaining,
                            total: 30, // can make this dynamic later 
                            refillDate: Date.now,
                            category: "General",
                            times: ["3AM", "6PM"], // Can also be made dynamic later
                            icon: selectedIcon
                        )
                        modelContext.insert(medicine)
                        dismiss()
                    } label: {
                        Text("Save Medicine")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray.opacity(0.4))
                            .cornerRadius(15)
                            .shadow(color: isFormValid ? Color.blue.opacity(0.3) : .clear, radius: 8, y: 4)
                    }
                    .disabled(!isFormValid)
                    .padding(.top, 10)
                    
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $isShowingScanner) {
                ScannerView(scannedText: $name)
                    .ignoresSafeArea()
            }
            .navigationTitle("New Medicine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

struct IconTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
        }
    }
}

#Preview {
    AddMedicineView()
        .modelContainer(for: Medicine.self, inMemory: true)
}
