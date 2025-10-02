//
//  EntryFormViewModel.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory
import SwiftUI
import SwiftData
import Observation

@Observable
final class EntryFormViewModel {
    
    @ObservationIgnored private let router: AppRouter
    @ObservationIgnored private let container: Container

    var isLoading = false
    var date: Date = .now
    var project: Project? = nil
    var timeRaw: String = ""
    var comment: String = ""
    var error: String? = nil

    var existingEntry: TimeEntry? = nil

    init(
        router: AppRouter,
        container: Container,
        existing: TimeEntry? = nil
    ) {
        self.router = router
        self.container = container
        
        if let ex = existing {
            existingEntry = ex
            date = ex.date
            project = ex.project
            timeRaw = TimeFormat.hhmm(from: ex.minutes)
            comment = ex.comment ?? ""
        }
    }

    func dismiss() {
        router.dismiss()
    }
    
    func onBlurFormat() {
        if let mins = TimeFormat.parse(timeRaw) {
            timeRaw = TimeFormat.hhmm(from: mins)
        }
    }

    func save() {
        withAnimation {
            isLoading = true
        }
        
        guard let user = container.userManager().currentUser else {
            error = "No user"
            withAnimation {
                isLoading = false
            }
            return
        }
        
        guard let project else {
            error = "Select a project"
            withAnimation {
                isLoading = false
            }
            return
        }
        
        guard let minutes = TimeFormat.parse(timeRaw) else {
            error = "Enter valid time"
            withAnimation {
                isLoading = false
            }
            return
        }
        
        let modalContext = ModelContainerManager.shared.sharedModelContainer.mainContext

        if let existingEntry {
            existingEntry.date = date
            existingEntry.project = project
            existingEntry.employee = user
            existingEntry.minutes = minutes
            existingEntry.comment = comment.isEmpty ? nil : comment
        } else {
            let entry = TimeEntry(
                date: date,
                minutes: minutes,
                comment: comment.isEmpty ? nil : comment,
                project: project,
                employee: user
            )
            modalContext.insert(entry)
        }
        
        user.lastSelectedProject = project
        
        do {
            try modalContext.save()
            
            withAnimation {
                isLoading = false
            }
            
            router.dismiss()
        } catch {
            self.error = error.localizedDescription
            withAnimation {
                isLoading = false
            }
            return
        }
    }
}
