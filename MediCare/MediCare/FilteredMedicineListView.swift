//
//  FilteredMedicineListView.swift
//  MediCare
//
//  Created by Harsh Virdi on 09/05/26.
//

import SwiftUI
import SwiftData

struct FilteredMedicineListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Medicine.name)]) var medicines: [Medicine]
    
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
        ForEach(medicines) {
            medicine in
            Button{
                logDose(for: medicine)
            } label: {
                VStack(alignment: .leading){
                    Text(medicine.name)
                        .font(.headline)
                        .foregroundStyle(.black)
                    Text(medicine.dosage)
                        .font(.caption)
                        .foregroundStyle(.black)
                    Text("Doses logged \(medicine.doseLog.count)")
                        .foregroundStyle(.black)
                }
            }
        }
        .onDelete(perform: deleteMedicine)
    }
    
    func logDose(for medicine: Medicine) {
            let doseLog = DoseLog(date: Date(), taken: true, medicine: medicine)
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
