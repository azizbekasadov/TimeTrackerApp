//
//  MainViewBuilder.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import Factory

extension Container {
    var mainViewModel: Factory<MainViewModel> {
        self { @MainActor in
            MainViewModel(
                container: self,
                router: self.appRouter()
            )
        }
    }
    
    var mainView: Factory<MainView> {
        self { @MainActor in
            MainView(viewModel: self.mainViewModel())
        }
    }
}

enum MainViewBuilder: BuilderType {
    @MainActor
    static func build(container: Container, context: MainViewContext) -> MainView {
        container.mainView()
    }
}
