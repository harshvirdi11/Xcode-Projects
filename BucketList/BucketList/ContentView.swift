//
//  ContentView.swift
//  BucketList
//
//  Created by Harsh Virdi on 05/03/26.
//

import MapKit
import SwiftUI

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
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .foregroundStyle(Color.red)
                            .frame(width: 44, height: 44)
                            .onTapGesture{
                                selectedLocation = location
                            }
                    }
                }
            }
            .onTapGesture{ position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let newLocation = Location(id: UUID(), name: "New Location", description: "", longitude: coordinate.longitude, latitude: coordinate.latitude)
                    locations.append(newLocation)
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
