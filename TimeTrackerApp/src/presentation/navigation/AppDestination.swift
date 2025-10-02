//
//  AppDestination.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation

public enum AppDestination: String, Hashable, Identifiable {
    case addTime
    case settings
    case auth
//    case onboarding
    
    public var id: String {
        self.rawValue
    }
}
