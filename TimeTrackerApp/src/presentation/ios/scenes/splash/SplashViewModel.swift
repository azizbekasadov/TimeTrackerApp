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

public protocol SplashViewModelable: AnyObject {
    func onAppear() async
    func bootstrap() async
    func didFinishLoading()
    
    var isLoaded: Bool { set get }
    var shouldShowError: Bool { set get }
    
    var error: SplashError? { set get }
    var isFinished: Bool { set get }
}

@Observable
public final class SplashViewModel: SplashViewModelable {
    private let router: AppRouter
    
    public var isFinished: Bool = false
    public var isLoaded: Bool = false
    public var shouldShowError: Bool = false
    
    public var error: SplashError?
    
    public init(
        router: AppRouter
    ) {
        self.router = router
    }
    
    public func onAppear() async {
        // TODO:
        // - add metrics loader
        withAnimation(.easeOut) {
            isLoaded = true
        }
    }
    
    // load dependencies and preload data if needed
    public func bootstrap() async {
        // TODO:
        // - setup loaders for the root dependencies of the app;
    }
    
    public func didFinishLoading() {
        self.isFinished = true
        
        NotificationCenter.default.post(name: .didFinishBooststrapInSplash, object: nil)
    }
}
