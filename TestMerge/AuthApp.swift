////
////  AuthApp.swift
////  AuthApp
////
////  Created by Antigravity
////
//
//import SwiftUI
//
///// Main app entry point
//@main
//struct AuthApp: App {
//    @StateObject private var authService = AuthenticationService.shared
//    
//    var body: some Scene {
//        WindowGroup {
//            Group {
//                if authService.isAuthenticated {
//                    HomeView()
//                        .transition(.opacity.combined(with: .scale))
//                } else {
//                    LoginView()
//                        .transition(.opacity.combined(with: .scale))
//                }
//            }
//            .animation(.easeInOut(duration: 0.3), value: authService.isAuthenticated)
//        }
//    }
//}
