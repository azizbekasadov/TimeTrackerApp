//
//  SettingsBuilder.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import Factory

extension Container {
    var settingsViewModel: Factory<SettingsViewModel> {
        self { @MainActor in
            SettingsViewModel(
                router: self.appRouter(),
                container: self
            )
        }
    }
    
    var settingsView: Factory<SettingsView> {
        self { @MainActor in
            SettingsView(viewModel: self.settingsViewModel())
        }
    }
}

enum SettingsBuilder: BuilderType {
    @MainActor
    static func build(container: Container, context: SettingsViewContext) -> SettingsView {
        container.settingsView()
    }
}
