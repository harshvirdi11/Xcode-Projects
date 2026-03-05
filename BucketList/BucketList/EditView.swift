//
//  EditView.swift
//  BucketList
//
//  Created by Harsh Virdi on 05/03/26.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var name: String
    @State private var description: String
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Edit name", text: $name)
                    TextField("Edit description", text: $description)
                }
            }
            .navigationTitle(Text("Place details"))
            .toolbar{
                Button("Done"){
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void){
        self.location = location
        self.onSave = onSave
        _name = .init(initialValue: location.name)
        _description = .init(initialValue: location.description)
    }
}

#Preview {
    EditView(location: .example) { _ in}
}
