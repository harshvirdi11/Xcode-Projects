//
//  ContentView.swift
//  iExpense
//
//  Created by Harsh Virdi on 03/02/26.
//

import SwiftUI

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses{
    var items: [ExpenseItem] = []
}

struct ContentView: View {
    @State var expenses: Expenses = Expenses()
    var body: some View {
        NavigationStack{
            List{
                ForEach(expenses.items){ item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button("Add Expense", systemImage: "plus"){
                    expenses.items.append(ExpenseItem(name: "Test", type: "Food", amount: 100.0))
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
