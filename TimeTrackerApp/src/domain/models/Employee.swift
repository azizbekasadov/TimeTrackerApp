//
//  Employee.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import SwiftData

@Model
class Employee {
    @Attribute(.unique) var id: UUID
    var name: String
    
    var username: String
    var password: String // hashed in the production
    var isAdmin: Bool
    
    @Relationship(deleteRule: .nullify, inverse: \Project.members)
    var favoriteProjects: [Project] = []
    var lastSelectedProject: Project?
    
    init(
        id: UUID = UUID(),
        name: String,
        username: String,
        password: String,
        isAdmin: Bool = false
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
        self.isAdmin = isAdmin
    }
}
