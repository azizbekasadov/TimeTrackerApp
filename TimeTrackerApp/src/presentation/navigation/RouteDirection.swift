//
//  RouteDirection.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Observation

 enum RouteDirection {
    case pop
    case push(destination: AppDestination)
    case root
}

 protocol Routing: AnyObject {
    func navigate(_ direction: RouteDirection)
}

@MainActor @Observable
 class AppRouter: Routing {
    var currentUser: Employee?
    
    @ObservationIgnored
     var navigationPath: NavigationPath
     var toolBarHiden: Bool
    
    var fullCover: AppDestination?
    
     init(
        _ navigationPath: NavigationPath = .init(),
        toolBarHiden: Bool = false
    ) {
        self.navigationPath = navigationPath
        self.toolBarHiden = toolBarHiden
    }
    
     func navigate(_ direction: RouteDirection) {
        switch direction {
        case .pop:
            navigationPath.removeLast()
        case .push(let destination):
            navigationPath.append(destination)
        case .root:
            navigationPath.removeLast(navigationPath.count)
        }
    }
    
     func present(_ destination: AppDestination) {
        if destination == .main {
            NotificationCenter.default.post(name: .didFinishBooststrapInSplash, object: nil)
//            fullCover = destination
            return
        }
        
        fullCover = destination
    }
    
     func dismiss() {
        fullCover = nil
    }
}
