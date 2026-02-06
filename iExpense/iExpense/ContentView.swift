//
//  ContentView.swift
//  iExpense
//
//  Created by Harsh Virdi on 03/02/26.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses{
    var items: [ExpenseItem] = [] {
        didSet{
            if let encoded = try? JSONEncoder().encode(items)
            {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "items")
        {
            if let loadedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems)
            {
                self.items = loadedItems
            }
        }
    }
}

struct ContentView: View {
    @State var showingAddExpense: Bool = false
    @State var expenses: Expenses = Expenses()
    var body: some View {
        NavigationStack{
            List{
                Section("Personal Expenses"){
                    let personalItems = expenses.items.filter{$0.type == "Personal"}
                    
                    if personalItems.isEmpty
                    {
                        Text("No personal expenses yet.")
                            .foregroundColor(.secondary)
                    }
                    else{
                        ForEach(personalItems){ item in
                            HStack{
                                VStack{
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
                    let businessItems = expenses.items.filter{$0.type == "Business"}
                    
                    if businessItems.isEmpty
                    {
                        Text("No business expenses yet.")
                            .foregroundColor(.secondary)
                    }
                    ForEach(businessItems){ item in
                        HStack{
                            VStack{
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
                    Button("Add Expense", systemImage: "plus"){
                        showingAddExpense = true
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet){
        let personalItems = expenses.items.filter{$0.type == "Personal"}
        for index in offsets{
            let itemToDelete = personalItems[index]
            
            if let mainIndex = expenses.items.firstIndex(where: {itemToDelete.id == $0.id}){
                expenses.items.remove(at: mainIndex)
            }
        }
    }
    
    func removeBusinessItems(at offsets: IndexSet){
        let businessItems = expenses.items.filter{$0.type == "Business"}
        for index in offsets{
            let itemToDelete = businessItems[index]
            
            if let mainIndex = expenses.items.firstIndex(where: {itemToDelete.id == $0.id}){
                expenses.items.remove(at: mainIndex)
            }
        }
    }
}

#Preview {
    ContentView()
}
