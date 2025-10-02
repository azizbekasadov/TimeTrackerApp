//
//  SplashError.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Factory
import Foundation
import Observation

 protocol SplashViewModelable: AnyObject {
    func onAppear() async
    func bootstrap() async
    func didFinishLoading()
    
    var isLoaded: Bool { set get }
    var shouldShowError: Bool { set get }
    
    var error: SplashError? { set get }
    var isFinished: Bool { set get }
}

@Observable
 final class SplashViewModel: SplashViewModelable {
    private let router: AppRouter
    
     var isFinished: Bool = false
     var isLoaded: Bool = false
     var shouldShowError: Bool = false
    
     var error: SplashError?
    
    init(
        router: AppRouter
    ) {
        self.router = router
    }
    
     func onAppear() async {
        // TODO:
        // - add metrics loader
        withAnimation(.easeOut) {
            isLoaded = true
        }
    }
    
    // load dependencies and preload data if needed
     func bootstrap() async {
        // TODO:
        // - setup loaders for the root dependencies of the app;
    }
    
     func didFinishLoading() {
        self.isFinished = true
        
        NotificationCenter.default.post(name: .didFinishBooststrapInSplash, object: nil)
    }
}
