//
//  PharmacyMapView.swift
//  MediCare
//
//  Created by Harsh Virdi on 11/05/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct PharmacyMapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var searchResults: [MKMapItem] = []
    @State private var locationManager = CLLocationManager()
    
    var body: some View {
        NavigationStack {
            Map(position: $position) {
                UserAnnotation()
                
                ForEach(searchResults, id: \.self) { pharmacy in
                    Marker(pharmacy.name ?? "Pharmacy", coordinate: pharmacy.placemark.coordinate)
                }
            }
            .mapControls{
                MapUserLocationButton()
                MapCompass()
            }
            .onAppear{
                locationManager.requestWhenInUseAuthorization()
                searchPharmacies()
            }
            .toolbar {
                ToolbarItem {
                    Button(role: .close) {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
            .navigationTitle("Nearby Pharmacies")
        }
    }
    
    func searchPharmacies() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "pharmacy"
        request.region = MKCoordinateRegion(
            center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 23.68, longitude: 86.97),
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                self.searchResults = response.mapItems
            }
        }
    }
}

#Preview {
    PharmacyMapView()
}
