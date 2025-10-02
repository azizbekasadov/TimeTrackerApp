//
//  AppDestination.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation

enum AppDestination: Hashable, Identifiable {
    case addTime
    case settings
    case auth
    case splash
    case dashboard
    case main
    case entryForm(entry: TimeEntry?)
    
    var id: String {
        switch self {
        case .addTime:
            return "addTime"
        case .settings:
            return "settings"
        case .auth:
            return "auth"
        case .splash:
            return "splash"
        case .dashboard:
            return "dashboard"
        case .main:
            return "main"
        case .entryForm:
            return "entryForm"
        }
    }
}
