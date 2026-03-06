//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Harsh Virdi on 06/03/26.
//

import CoreLocation
import Contacts
import Foundation
import MapKit
import SwiftUI
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedLocation: Location?
        let savedPath = URL.documentsDirectory.appendingPathComponent("SavedPlaces")
        var isUnlocked = false
        
        func addLocation(point: CLLocationCoordinate2D)
        {
            let newLocation = Location(id: UUID(), name: "Searching...", description: "", longitude: point.longitude, latitude: point.latitude)
            locations.append(newLocation)
            
            Task {
                let locationToReverseGeocode = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
                    do {
                        guard let request = MKReverseGeocodingRequest(location: locationToReverseGeocode) else {throw URLError(.badURL)}
                        let items = try await request.mapItems
                        guard let first = items.first else{throw URLError(.zeroByteResource)}
                            let newName = first.placemark.locality ?? "New Destination"
                                await MainActor.run {
                                    if let index = locations.firstIndex(of: newLocation){
                                        locations[index].name = newName
                                        save()
                                    }
                                }
                    } catch {
                        // If reverse geocoding fails, keep the default name
                        await MainActor.run {
                            if let index = locations.firstIndex(of: newLocation){
                                locations[index].name = "New Destination"
                                save()
                            }
                        }
                    }
                }
            }
        
        func updateLocation(old location: Location, new newLocation: Location){
            if let index = locations.firstIndex(of: location) {
                locations[index] = newLocation
                save()
            }
        }
        
        func save(){
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savedPath, options: [.atomic, .completeFileProtection])
            }
            catch{
                print("Unable to save data")
            }
        }
        
        func delete(_ location: Location) {
            if let index = locations.firstIndex(of: location) {
                locations.remove(at: index)
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            Task {
                do {
                    let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to continue")
    
                    if success {
                        await MainActor.run{
                            isUnlocked = true
                        }
                    }
                } catch {
                    print("Authentication failed: \(error.localizedDescription)")
                }
            }
        }

        
        init() {
            do {
                let data = try Data(contentsOf: savedPath)
                locations = try JSONDecoder().decode([Location].self, from: data)
                
                
            } catch{
                locations = []
            }
        }
    }
}
