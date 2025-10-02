//
//  SettingsViewModel.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory
import Foundation
import Observation

@Observable
final class SettingsViewModel {
    @ObservationIgnored private let router: AppRouter
    @ObservationIgnored private var container: Container

    init(
        router: AppRouter,
        container: Container
    ) {
        self.router = router
        self.container = container
    }
}
