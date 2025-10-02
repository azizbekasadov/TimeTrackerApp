//
//  DashboardBuilder.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory

extension Container {
    var dashboardViewModel: Factory<DashboardViewModel> {
        self { @MainActor in
            DashboardViewModel(
                router: self.appRouter(),
                container: self
            )
        }
    }
    
    var dashboardView: Factory<DashboardView> {
        self { @MainActor in
            DashboardView(viewModel: self.dashboardViewModel())
        }
    }
}

enum DashboardBuilder: BuilderType {
    @MainActor
    static func build(container: Container, context: DashboardViewContext) -> DashboardView {
        container.dashboardView()
    }
}
