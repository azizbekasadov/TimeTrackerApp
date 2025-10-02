//
//  Project.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import SwiftData

@Model
final class Project: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    
    var isActive: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \TimeEntry.project)
    var entries: [TimeEntry] = []
    
    @Relationship(deleteRule: .nullify)
    var members: [Employee] = []

    init(
        id: UUID = UUID(),
        name: String,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.isActive = isActive
    }
}
