//
//  UserManager.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import Factory

struct UserManager {
    static let shared = UserManager()
    
    var currentUser: Employee?
    
    private init() {
        if let currentId = UserDefaults.standard.string(forKey: "currentEmployeeID") {
            let employees: [Employee] = ModelContainerManager.shared.fetch()
            self.currentUser = employees.first(where: { $0.id.uuidString == currentId })
        }
    }
}

extension Container {
    var userManager: Factory<UserManager> {
        self { @MainActor in
            UserManager.shared
        }
    }
}
