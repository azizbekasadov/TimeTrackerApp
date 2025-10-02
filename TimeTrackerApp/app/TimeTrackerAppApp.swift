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
        }
    }
}
