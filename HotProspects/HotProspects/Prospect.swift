//
//  Prospect.swift
//  HotProspects
//
//  Created by Harsh Virdi on 10/03/26.
//

import Foundation
import SwiftData

@Model
class Prospect: Identifiable {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var dateAdded = Date()
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.dateAdded = Date.now
    }
    
    static let example = Prospect(name: "Harsh Virdi", emailAddress: "harsh@example.com", isContacted: false)
}
