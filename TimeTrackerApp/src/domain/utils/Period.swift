//
//  Period.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation

enum Period: String, CaseIterable, Identifiable {
    case day
    case week
    case month
    case year
    
    var id: String {
        self.rawValue
    }
}
