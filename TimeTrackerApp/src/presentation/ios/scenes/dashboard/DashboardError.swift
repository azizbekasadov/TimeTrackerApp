//
//  DashboardError.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation

enum DashboardError: Error {
    case failedToLoadProjects
    case noProjectsFound
    case noInternetConnection
    case unknownError
    case other(String)
}
