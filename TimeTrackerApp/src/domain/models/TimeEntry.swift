//
//  TimeEntry.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import SwiftData

@Model
final class TimeEntry: Identifiable {
    @Attribute(.unique) var id: UUID
    
    var date: Date
    var minutes: Int
    var comment: String?
    
    @Relationship(deleteRule: .nullify) var project: Project?
    @Relationship(deleteRule: .nullify) var employee: Employee?

    init(
        id: UUID = UUID(),
        date: Date,
        minutes: Int,
        comment: String? = nil,
        project: Project?,
        employee: Employee?
    ) {
        self.id = id
        self.date = date
        self.minutes = minutes
        self.comment = comment
        self.project = project
        self.employee = employee
    }
}
