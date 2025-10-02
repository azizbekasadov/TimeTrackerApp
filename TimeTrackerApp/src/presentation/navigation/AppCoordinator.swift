//
//  AppCoordinator.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Factory

struct AppCoordinator: View {
    var currentUser: Employee? = nil
    
    @State private(set) var router: AppRouter
    @State private var isFinishedColdLoading = false
    
    private let container: Container

    init(container: Container) {
        self.container = container
        self.router = container.appRouter()
    }

    var body: some View {
        Group {
            if isFinishedColdLoading {
                NavigationStack(path: $router.navigationPath) {
                    Group {
                        if container.userManager().currentUser == nil {
                            AppDestinationBuilder.build(.auth, with: container)
                        } else {
                            AppDestinationBuilder.build(.main, with: container)
                        }
                    }
                    .navigationBarTitleDisplayMode(.large)
                    .navigationViewStyle(.stack)
                    .navigationDestination(for: AppDestination.self) { destination in
                        AppDestinationBuilder.build(
                            destination,
                            with: self.container
                        )
                    }
                }
                .fullScreenCover(item: $router.fullCover) { destination in
                    AppDestinationBuilder.build(destination, with: container)
                }
            } else {
                 AppDestinationBuilder.build(.splash, with: container)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .didFinishBooststrapInSplash)) { output in
            self.isFinishedColdLoading = true
        }
    }
}
