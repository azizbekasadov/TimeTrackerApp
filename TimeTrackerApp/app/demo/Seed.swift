//
//  Seed.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import SwiftData

enum Seed {
    static let didSeedKey = "didSeedTimeTracker"
    
    static func runIfNeeded(in container: ModelContainer) {
        // do smth with mock data
        let ctx = ModelContext(container)
        
        if UserDefaults.standard.bool(forKey: didSeedKey) {
            return
        }
        
        let admin = Employee(name: "Admin", username: "admin", password: "admin", isAdmin: true)
        let alice = Employee(name: "Alice", username: "alice", password: "alice")
        let bob = Employee(name: "Bob", username: "bob", password: "bob")
        let projA = Project(name: "iOS App")
        let projB = Project(name: "Backend API")
        admin.favoriteProjects = [projA, projB]
        alice.favoriteProjects = [projA]
        bob.favoriteProjects = [projB]
        alice.lastSelectedProject = projA
        bob.lastSelectedProject = projB
        
        ctx.insert(admin); ctx.insert(alice); ctx.insert(bob); ctx.insert(projA); ctx.insert(projB)
        
        let today = Calendar.current.startOfDay(for: .now)
        ctx.insert(TimeEntry(date: today, minutes: 120, comment: "Standup + features", project: projA, employee: alice))
        ctx.insert(TimeEntry(date: today, minutes: 75, comment: "Bugfixes", project: projA, employee: alice))
        ctx.insert(TimeEntry(date: today, minutes: 150, comment: "Auth endpoints", project: projB, employee: bob))
        
        try? ctx.save()
        UserDefaults.standard.set(true, forKey: didSeedKey)
    }
}
