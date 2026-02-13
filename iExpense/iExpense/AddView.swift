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
    @State private var amount: Double?
    let types: [String] = ["Personal", "Business"]
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("eg. Groceries", text: $name)
                    .focused($amountIsFocused)
                
                Picker("Expense Type", selection: $type){
                    ForEach(types, id: \.self){
                        Text("\($0)")
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
            }
            .navigationTitle("Add Expense")
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem{
                    Button{
                        expenses.items.append(ExpenseItem(name: name, type: type, amount: amount ?? 0.0))
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
                ToolbarItem(placement:.cancellationAction){
                    Button{
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button{
                        amountIsFocused = false
                    } label:{
                            Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }            
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
