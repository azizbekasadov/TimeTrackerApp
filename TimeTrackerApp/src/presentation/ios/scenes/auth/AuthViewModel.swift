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
    
    var isLoading = false
    
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
        isLoading = true
        do {
            let descriptor = FetchDescriptor<Employee>(
                predicate: #Predicate {
                    $0.username == username
                }
            )
            
            let results = try ModelContainerManager.shared.sharedModelContainer.mainContext.fetch(descriptor)
            
            guard let user = results.first(where: { $0.username == self.username }), user.password == password else {
                error = "Invalid credentials"
                isLoading = false
                return
            }
            
            lastUsername = username
            router.currentUser = user
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
                
                UserDefaults.standard.set(user.id.uuidString, forKey: "currentEmployeeID")
                
                self.router.dismiss()
                self.router.present(.main)
            }
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
}
