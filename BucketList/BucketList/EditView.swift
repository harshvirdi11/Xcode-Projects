//
//  EditView.swift
//  BucketList
//
//  Created by Harsh Virdi on 05/03/26.
//

import SwiftUI

struct EditView: View {
    enum LoadingStates {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var alertShowing: Bool = false
    @State private var name: String
    @State private var description: String
    @State private var loadingState = LoadingStates.loading
    @State private var pages = [Page]()
    var onSave: (Location) -> Void
    var onDelete: (Location) -> Void
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Edit name", text: $name)
                    TextField("Edit description", text: $description)
                }
                
                Section("Nearby..."){
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
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
            .alert("Are you sure?", isPresented: $alertShowing){
                Button("Delete", role: .destructive){
                    onDelete(location)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
            .toolbar{
                ToolbarItem {
                    Button("Done"){
                        var newLocation = location
                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.description = description
                        onSave(newLocation)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading){
                    Button(role: .destructive){
                        alertShowing.toggle()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void){
        self.location = location
        self.onSave = onSave
        self.onDelete = onDelete
        _name = .init(initialValue: location.name)
        _description = .init(initialValue: location.description)
    }
    
    func fetchNearbyPlaces() async{
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
    
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
    
        } catch{
            loadingState = .failed
        }
    }
}

#Preview {
    EditView(location: .example) { _ in} onDelete: {_ in }
}
