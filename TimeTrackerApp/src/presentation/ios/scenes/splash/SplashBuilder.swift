//
//  SplashBuilder.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory

extension Container {
    var splashViewModel: Factory<SplashViewModel> {
        self { SplashViewModel(router: self.appRouter()) }
    }
    
    var splashView: Factory<SplashView> {
        self { @MainActor in
            SplashView(viewModel: self.splashViewModel())
        }
    }
}

 enum SplashBuilder: BuilderType {
     typealias Context = SplashViewContext
     typealias ViewType = SplashView
    
    @MainActor
    static  func build(container: Container, context: SplashBuilder.Context) -> ViewType {
        container.splashView()
    }
}
