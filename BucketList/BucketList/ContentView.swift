//
//  ContentView.swift
//  BucketList
//
//  Created by Harsh Virdi on 05/03/26.
//

import MapKit
import CoreLocation
import SwiftUI
import Contacts

enum mapMode: String, CaseIterable{
    case standard = "standard"
    case hybrid = "hybrid"
    
    var mapStyle: MapStyle {
        switch self {
            case .standard:
            return .standard
            case .hybrid:
            return .hybrid
        }
    }
}

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var viewModel = ViewModel()
    @State private var selectedMode = mapMode.standard
    
    var body: some View {
        if viewModel.isUnlocked {
            NavigationStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition)
                    {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate){
                                VStack{
                                    Image(systemName: "mappin.and.ellipse")
                                        .resizable()
                                        .foregroundStyle(Color.red)
                                        .frame(width: 44, height: 44)
                                        .onTapGesture{
                                            guard location.name != "Searching..." else { return }
                                            viewModel.selectedLocation = location
                                        }
                                    if location.name == "Searching..."{
                                        ProgressView()
                                            .scaleEffect(0.5)
                                    }
                                }
                            }
                        }
                    }
                    .mapStyle(selectedMode.mapStyle)
                    .onTapGesture{ position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(point: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedLocation){
                        location in
                        EditView(location: location) {
                            newLocation in
                            viewModel.updateLocation(old: location, new: newLocation)
                        } onDelete: { location in
                            viewModel.delete(location)
                        }
                    }
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: viewModel.selectedLocation)
                .sensoryFeedback(.impact(weight: .heavy), trigger: viewModel.locations)
                .toolbar{
                    ToolbarItem {
                        Menu {
                            Picker("Map Style", selection: $selectedMode) {
                                ForEach(mapMode.allCases, id: \.self) { style in
                                    Text(style.rawValue).tag(style)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.2.squarepath")
                        }
                    }
                }
            }
        }
        
        else {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                Button("Unlock", action: viewModel.authenticate)
                    .font(.title)
                    .padding()
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
    }
}

#Preview {
    ContentView()
}
