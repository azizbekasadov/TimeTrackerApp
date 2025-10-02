//
//  BuilderType.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory

public protocol BuilderType {
    associatedtype Context // applicable to rerendable views
    associatedtype ViewType
    
    @MainActor
    static func build(
        container: Container,
        context: Context
    ) -> ViewType
}
