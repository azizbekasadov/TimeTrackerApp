//
//  SplashBuilder.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory

public extension Container {
    var splashViewModel: Factory<SplashViewModel> {
        self { SplashViewModel(router: self.appRouter()) }
    }
    
    var splashView: Factory<SplashView> {
        self { @MainActor in
            SplashView(viewModel: self.splashViewModel())
        }
    }
}

public enum SplashBuilder: BuilderType {
    public typealias Context = SplashViewContext
    public typealias ViewType = SplashView
    
    @MainActor
    static public func build(container: Container, context: SplashBuilder.Context) -> ViewType {
        container.splashView()
    }
}
