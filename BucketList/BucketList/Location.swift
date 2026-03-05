//
//  Location.swift
//  BucketList
//
//  Created by Harsh Virdi on 05/03/26.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable{
    var id: UUID
    var name: String
    var description: String
    var longitude: Double
    var latitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG
    static let example: Location = Location(id: UUID(), name: "Example Location", description: "This is an example location", longitude: 12.34, latitude: 56.78)
    #endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
