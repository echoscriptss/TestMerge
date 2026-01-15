//
//  TestMergeApp.swift
//  TestMerge
//
//  Created by Yogesh on 1/15/26.
//

import SwiftUI

@main
struct TestMergeApp: App {
    @StateObject private var authService = AuthenticationService.shared
    
    var body: some Scene {
        WindowGroup {
            // BASE
            Group {
                if authService.isAuthenticated {
                    HomeView()
                        .transition(.opacity.combined(with: .scale))
                } else {
                    LoginView()
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authService.isAuthenticated)
        }
    }
}
