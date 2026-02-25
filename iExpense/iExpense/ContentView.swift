//
//  ContentView.swift
//  iExpense
//
//  Created by Harsh Virdi on 03/02/26.
//

import SwiftUI
import SwiftData

@Model
class ExpenseItem{
    var name: String
    var type: String
    var amount: Double
    var date: Date
    
    init(name: String, type: String, amount: Double, date: Date = .now) {
        self.name = name
        self.type = type
        self.amount = amount
        self.date = date
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ExpenseItem.date) var expenses: [ExpenseItem]
    var body: some View {
        NavigationStack{
            List{
                Section("Personal Expenses"){
                    let personalItems = expenses.filter{$0.type == "Personal"}
                    
                    if personalItems.isEmpty
                    {
                        Text("No personal expenses yet.")
                            .foregroundColor(.secondary)
                    }
                    else{
                        ForEach(personalItems){ item in
                            HStack{
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .font(Font.headline)
                                    Text(item.type)
                                        .font(Font.caption)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(Font.headline)
                                    .foregroundStyle(item.amount <= 10 ? Color.green : item.amount <= 100 ? Color.orange : Color.red)
                            }
                        }
                        .onDelete(perform: removePersonalItems)
                    }
                }
    
                
                Section("Business Expenses"){
                    let businessItems = expenses.filter{$0.type == "Business"}
                    
                    if businessItems.isEmpty
                    {
                        Text("No business expenses yet.")
                            .foregroundColor(.secondary)
                    }
                    ForEach(businessItems){ item in
                        HStack{
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(Font.headline)
                                Text(item.type)
                                    .font(Font.caption)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(Font.headline)
                                .foregroundStyle(item.amount <= 10 ? Color.green : item.amount <= 100 ? Color.orange : Color.red)
                        }
                    }
                    .onDelete(perform: removeBusinessItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar{
                ToolbarItem{
                    NavigationLink{
                        AddView()
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet){
        let personalItems = expenses.filter{$0.type == "Personal"}
        for index in offsets{
            let itemToDelete = personalItems[index]
            
            if let mainIndex = expenses.firstIndex(where: {itemToDelete.id == $0.id}){
                modelContext.delete(expenses[mainIndex])
            }
        }
    }
    
    func removeBusinessItems(at offsets: IndexSet){
        let businessItems = expenses.filter{$0.type == "Business"}
        for index in offsets{
            let itemToDelete = businessItems[index]
            
            if let mainIndex = expenses.firstIndex(where: {itemToDelete.id == $0.id}){
                modelContext.delete(expenses[mainIndex])
            }
        }
    }
}

#Preview {
    ContentView()
}
