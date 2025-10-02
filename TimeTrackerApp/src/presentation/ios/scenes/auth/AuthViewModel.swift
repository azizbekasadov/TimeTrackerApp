//
//  AuthViewModel.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Combine
import Factory
import SwiftData
import Foundation
import Observation

protocol AuthViewModelable: AnyObject {
    
    @MainActor
    func onAppear() async
}

@Observable
final class AuthViewModel: AuthViewModelable {
    
    @ObservationIgnored private let router: AppRouter
    @ObservationIgnored private var container: Container
    
    @ObservationIgnored
    @AppStorage("lastUsername") private var lastUsername: String = ""
    
    var username: String = ""
    var password: String = ""
    var error: String? = nil
    
    init(
        router: AppRouter,
        container: Container
    ) {
        self.router = router
        self.container = container
    }
    
    @MainActor
    func onAppear() async {
        
    }
    
    @MainActor
    func login() async {
        do {
            let descriptor = FetchDescriptor<Employee>(
                predicate: #Predicate {
                    $0.username == username
                }
            )
            
            let results = try ModelContainerManager.shared.sharedModelContainer.mainContext.fetch(descriptor)
            
            guard let user = results.first, user.password == password else {
                error = "Invalid credentials"
                return
            }
            
            lastUsername = username
            router.currentUser = user
            router.navigate(.root)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
