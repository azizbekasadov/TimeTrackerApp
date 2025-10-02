//
//  MainViewModel.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory
import SwiftUI
import SwiftData
import Observation

@Observable
final class MainViewModel {
    private(set) var allEntries: [TimeEntry] = []
    
    private(set) var activeProjects: [Project] = []
    
    @ObservationIgnored private let container: Container
    @ObservationIgnored private let router: AppRouter

    var period: Period = .week
    var selectedDate: Date = .now
    var selectedProject: Project? = nil
    var selectedEmployee: Employee? = nil // admin filter

    var currentUser: Employee? {
        container.userManager().currentUser
    }
    
    var isAdmin: Bool {
        currentUser?.isAdmin ?? false
    }

    init(
        container: Container,
        router: AppRouter
    ) {
        self.container = container
        self.router = router
        self.selectedProject = currentUser?.lastSelectedProject
    }
    
    func showEntryForm(for entry: TimeEntry) {
        router.present(.entryForm(entry: entry))
    }
    
    func fetchAllEntries() {
        let sortDescriptor = SortDescriptor<TimeEntry>(\TimeEntry.date, order: .reverse)
        self.allEntries = ModelContainerManager.shared.fetch(
            sortDescriptors: [sortDescriptor]
        )
    }
    
    func fetchActiveProjects() {
        let sortDescriptor = SortDescriptor<Project>(\Project.name, order: .reverse)
        self.activeProjects = ModelContainerManager.shared.fetch(
            sortDescriptors: [sortDescriptor]
        )
        .filter(\.isActive)
    }
    
    func onAppear() {
        fetchAllEntries()
        fetchActiveProjects()
        
        if
            self.selectedProject == nil,
            let project = self.currentUser?.lastSelectedProject {
            self.selectedProject = project
        }
    }
    
    func totalMinutes(entries: [TimeEntry]) -> Int {
        entries.reduce(0) { $0 + $1.minutes }
    }

    func delete(_ entry: TimeEntry) {
        ModelContainerManager.shared.delete(entry)
        
        self.fetchActiveProjects()
        self.fetchAllEntries()
    }
    
    func showDashboard() {
        router.navigate(.push(destination: .dashboard))
    }
    
    func showSettings() {
        router.present(.settings)
    }
    
    func showEntryForm(for entryId: UUID? = nil) {
        router.present(.addTime)
    }
    
    func fetchEmployees() -> [Employee] {
        ModelContainerManager.shared.fetch(
            sortDescriptors: [SortDescriptor(\Employee.name)]
        )
    }
    
    func selectEmployee(_ employeeID: UUID?) {
        guard let employeeID else {
            return
        }
        
        self.selectedEmployee = fetchEmployees().first(where: { $0.id == employeeID })
    }
    
    var filteredEntries: [TimeEntry] {
        let user = self.selectedEmployee ?? self.currentUser
        let calendar = Calendar.current
        
        let range = calendar.range(
            for: period,
            containing: selectedDate
        )
        
        return allEntries.filter { entry in
            if
                let user,
                entry.employee?.id != user.id
            {
                return self.isAdmin
            }
            
            let inUserScope = self.isAdmin ? (selectedEmployee == nil || entry.employee?.id == selectedEmployee?.id) : (entry.employee?.id == user?.id)
            let inProject = selectedProject == nil || entry.project?.id == selectedProject?.id
            let inRange = (range.start...range.end).contains(entry.date)
            
            return inUserScope && inProject && inRange
        }
    }
}
