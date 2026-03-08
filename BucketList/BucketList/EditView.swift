//
//  EditView.swift
//  BucketList
//
//  Created by Harsh Virdi on 05/03/26.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    var onSave: (Location) -> Void
    var onDelete: (Location) -> Void
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Edit name", text: $viewModel.name)
                    TextField("Edit description", text: $viewModel.description)
                }
                
                Section("Nearby..."){
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(Font.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Failed to load data")
                    }
                }
            }
            .navigationTitle(Text("Place details"))
            .alert("Are you sure?", isPresented: $viewModel.alertShowing){
                Button("Delete", role: .destructive){
                    onDelete(viewModel.location)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
            .toolbar{
                ToolbarItem {
                    Button("Done"){
                        var newLocation = viewModel.location
                        newLocation.id = UUID()
                        newLocation.name = viewModel.name
                        newLocation.description = viewModel.description
                        onSave(newLocation)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading){
                    Button(role: .destructive){
                        viewModel.alertShowing.toggle()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
   
    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void){
        _viewModel = State(initialValue: ViewModel(location: location))
        self.onSave = onSave
        self.onDelete = onDelete
    }
}

#Preview {
    EditView(location: .example) { _ in} onDelete: {_ in }
}
