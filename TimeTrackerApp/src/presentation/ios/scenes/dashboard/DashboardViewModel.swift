//
//  DashboardViewModel.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Combine
import Factory
import SwiftData
import Foundation
import Observation

@Observable
final class DashboardViewModel {
    @ObservationIgnored
    private let router: AppRouter
    
    @ObservationIgnored
    private let container: Container
    
    init(
        router: AppRouter,
        container: Container
    ) {
        self.router = router
        self.container = container
    }
    
    var currentUser: Employee? {
        container.userManager().currentUser
    }
    
    var period: Period = .week
    var selectedDate: Date = .now

    func dateRange() -> (Date, Date) {
        let c = Calendar.current
        let r = c.range(for: period, containing: selectedDate)
        return (r.start, r.end)
    }
}
