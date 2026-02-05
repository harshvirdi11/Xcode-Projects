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
                ForEach(expenses.items){ item in
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
                .onDelete(perform: removeItems)
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
    
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
