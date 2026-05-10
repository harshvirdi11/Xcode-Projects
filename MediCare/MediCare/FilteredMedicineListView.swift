import SwiftUI
import SwiftData

struct FilteredMedicineListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var medicines: [Medicine]
    
    init(searchText: String) {
        let predicate = #Predicate<Medicine> { medicine in
            if searchText.isEmpty {
                return true
            } else {
                return medicine.name.localizedStandardContains(searchText)
            }
        }
        _medicines = Query(filter: predicate, sort: [SortDescriptor(\Medicine.name)])
    }
    
    var body: some View {
        ForEach(medicines) { medicine in
            // MARK: - The Medicine Card
            HStack(spacing: 15) {
                // MARK: - Colorful Icon Badge
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Text(medicine.icon)
                        .font(.title2)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(medicine.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("\(medicine.dosage) • \(medicine.frequency)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Remaining: \(medicine.remaining)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(medicine.remaining <= 5 ? .red : .green)
                }
                
                Spacer()
                
                // Checkmark button
                Button {
                    logDose(for: medicine)
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .onDelete(perform: deleteMedicine)
    }
    
    func logDose(for medicine: Medicine) {
        let doseLog = DoseLog(date: Date(), taken: true, medicine: medicine)
        medicine.remaining -= 1
        modelContext.insert(doseLog)
    }
    
    func deleteMedicine(offsets: IndexSet) {
        for offset in offsets {
            let medicine = medicines[offset]
            modelContext.delete(medicine)
        }
    }
}

#Preview {
    FilteredMedicineListView(searchText: "")
}
