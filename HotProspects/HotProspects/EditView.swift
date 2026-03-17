//
//  EditView.swift
//  HotProspects
//
//  Created by Harsh Virdi on 17/03/26.
//

import SwiftUI

struct EditView: View {
    
    @Bindable var prospect: Prospect
    @State private var name: String = ""
    @State private var email: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            Form{
                Section("Name")
                {
                    TextField(name, text: $name)
                }
                
                Section("Email")
                {
                    TextField(email, text: $email)
                }
            }
            .navigationTitle("Edit details")
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .topBarTrailing)
                {
                    Button {
                        prospect.name = name
                        prospect.emailAddress = email
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.bordered)
                    .disabled(name.isEmpty || email.isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction){
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                }
            }
    }
    
    init(prospect: Prospect) {
        self.prospect = prospect
        _name = State(initialValue: prospect.name)
        _email = State(initialValue: prospect.emailAddress)
    }
}

#Preview {
    NavigationStack{
        EditView(prospect: Prospect.example)
    }
}
