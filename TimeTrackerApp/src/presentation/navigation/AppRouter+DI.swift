//
//  AppRouter+DI.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory

extension Container {
  
  var appRouter: Factory<AppRouter> {
        self { @MainActor in
            AppRouter()
        }
        .scope(.singleton)
    }
  
}
