//
//  AddView.swift
//  iExpense
//
//  Created by Harsh Virdi on 05/02/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    var expenses: Expenses
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: Double = 0.0
    let types: [String] = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("eg. Groceries", text: $name)
                
                Picker("Expense Type", selection: $type){
                    ForEach(types, id: \.self){
                        Text("\($0)")
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Expense")
            .toolbar{
                Button{
                    expenses.items.append(ExpenseItem(name: name, type: type, amount: amount))
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
