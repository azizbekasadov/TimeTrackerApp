//
//  TimeTrackerAppApp.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Factory
import SwiftData

@main
struct TimeTrackerAppApp: App {
    private let container = Container()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinator(container: container)
                .modelContainer(ModelContainerManager.shared.sharedModelContainer)
        }
    }
}

extension EnvironmentValues {
    @Entry public var modelContext: ModelContext = ModelContainerManager.shared.sharedModelContainer.mainContext
}

struct ModelContainerManager {
    static let shared = ModelContainerManager()
    
    private(set) var sharedModelContainer: ModelContainer = {
        let schema = Schema([Employee.self, Project.self, TimeEntry.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: schema, configurations: config)
//        Seed.runIfNeeded(in: container)
        return container
    }()
    
    private init() {}
}
