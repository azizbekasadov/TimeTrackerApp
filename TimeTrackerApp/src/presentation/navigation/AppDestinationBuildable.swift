//
//  AppDestinationBuildable.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Factory

protocol AppDestinationBuildable {
    
    @MainActor 
    static func build(
        _ destination: AppDestination,
        with container: Container
    ) -> AnyView
}

enum AppDestinationBuilder: AppDestinationBuildable {
//    @escaping (D) -> C) -> some View where D : Hashable, C : View
    @MainActor
    static func build(
        _ destination: AppDestination,
        with container: Container
    ) -> AnyView {
        switch destination {
        case .splash:
            return AnyView(SplashBuilder.build(
                container: container,
                context: SplashViewContext()
            ))
        case .dashboard:
            return AnyView(
                DashboardBuilder.build(
                    container: container,
                    context: DashboardViewContext()
                )
            )
        case .main:
            return AnyView(
                NavigationStack(root: {
                    MainViewBuilder.build(
                        container: container,
                        context: MainViewContext()
                    )
                })
            )
        case .addTime:
            return AnyView(
                EntryFormView(
                    viewModel: EntryFormViewModel(
                        router: container.appRouter(),
                        container: container,
                        existing: nil
                    )
                )
            )
        case .settings:
            return AnyView(
                SettingsBuilder.build(
                    container: container,
                    context: SettingsViewContext()
                )
            )
        case .auth:
            return AnyView(
                AuthBuilder.build(
                    container: container,
                    context: AuthViewContext()
                )
            )
        case .entryForm(let entry):
            return AnyView(
                EntryFormView(
                    viewModel: EntryFormViewModel(
                        router: container.appRouter(),
                        container: container,
                        existing: entry
                    )
                )
            )
        }
    }
}
