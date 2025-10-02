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
        case .addTime:
            return AnyView(VStack{})
        case .settings:
            return AnyView(VStack{})
        case .auth:
            return AnyView(VStack{})
        }
    }
}
