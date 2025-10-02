//
//  AuthBuilder.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import Factory

extension Container {
    var authViewModel: Factory<AuthViewModel> {
        self { @MainActor in
            AuthViewModel(
                router: self.appRouter(),
                container: self
            )
        }
    }
    
    var authView: Factory<AuthView> {
        self { @MainActor in
            AuthView(viewModel: self.authViewModel())
        }
    }
}

enum AuthBuilder: BuilderType {
    @MainActor
    static func build(
        container: Container,
        context: AuthViewContext
    ) -> AuthView {
        container.authView()
    }
}
