//
//  MedicineListView.swift
//  MediCare
//
//  Created by Harsh Virdi on 08/05/26.
//

import SwiftUI
import SwiftData

struct MedicineListView: View {
    
    @State private var isPresented: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                FilteredMedicineListView(searchText: searchText)
            }
            .navigationTitle(Text("Medicines"))
            .searchable(text: $searchText, prompt: Text("Search Medicines"))
            .sheet(isPresented: $isPresented){
                AddMedicineView()
            }
            .toolbar{
                Button{
                    isPresented.toggle()
                } label: {
                    Text("Add Medicine")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    MedicineListView()
        .modelContainer(for: Medicine.self, inMemory: true)
}
