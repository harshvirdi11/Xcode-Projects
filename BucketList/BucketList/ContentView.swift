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

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    @State private var locations = [Location]()
    @State private var selectedLocation: Location?
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition)
            {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate){
                        VStack{
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .foregroundStyle(Color.red)
                                .frame(width: 44, height: 44)
                                .onTapGesture{
                                    guard location.name != "Searching..." else { return }
                                    selectedLocation = location
                                }
                            if location.name == "Searching..."{
                                ProgressView()
                                    .scaleEffect(0.5)
                            }
                        }
                    }
                }
            }
            .onTapGesture{ position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let newLocation = Location(id: UUID(), name: "Searching...", description: "", longitude: coordinate.longitude, latitude: coordinate.latitude)
                    locations.append(newLocation)
                    
                    Task {
                        let locationToReverseGeocode = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
                        if let request = MKReverseGeocodingRequest(location: locationToReverseGeocode) {
                            do {
                                let items = try await request.mapItems
                                if let first = items.first {
                                    let newName = first.placemark.locality ?? "New Destination"
                                        await MainActor.run {
                                            if let index = locations.firstIndex(of: newLocation){
                                                locations[index].name = newName
                                            }
                                        }
                                }
                            } catch {
                                // If reverse geocoding fails, keep the default name
                                await MainActor.run {
                                    if let index = locations.firstIndex(of: newLocation){
                                        locations[index].name = "New Destination"
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .sheet(item: $selectedLocation){
                location in
                EditView(location: location) {
                    newLocation in
                    if let index = locations.firstIndex(of: location) {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
