//
//  RouteDirection.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Observation

public enum RouteDirection {
    case pop
    case push(destination: AppDestination)
    case root
}

public protocol Routing: AnyObject {
    func navigate(_ direction: RouteDirection)
}

@MainActor @Observable
public class AppRouter: Routing {
    var currentUser: Employee?
    
    @ObservationIgnored
    public var navigationPath: NavigationPath
    public var toolBarHiden: Bool
    
    public var fullCover: AppDestination?
    
    public init(
        _ navigationPath: NavigationPath = .init(),
        toolBarHiden: Bool = false
    ) {
        self.navigationPath = navigationPath
        self.toolBarHiden = toolBarHiden
    }
    
    public func navigate(_ direction: RouteDirection) {
        switch direction {
        case .pop:
            navigationPath.removeLast()
        case .push(let destination):
            navigationPath.append(destination)
        case .root:
            navigationPath.removeLast(navigationPath.count)
        }
    }
    
    public func present(_ destination: AppDestination) {
        fullCover = destination
    }
    
    public func dismiss() {
        fullCover = nil
    }
}
