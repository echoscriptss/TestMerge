//
//  LoginViewModel.swift
//  AuthApp
//
//  Created by Antigravity
//

import Foundation
import Combine

/// ViewModel for the login screen
class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// User's email input
    @Published var email: String = ""
    
    /// User's password input ass
    @Published var password: String = ""
    
    
    // added new comment
    /// Error message to display to the user
    @Published var errorMessage: String = ""
    
    /// Whether a login request is in progress
    @Published var isLoading: Bool = false
    
    /// Whether login was successful
    @Published var isAuthenticated: Bool = false
    
    private let authService = AuthenticationService.shared
    
    // MARK: - Methods
    
    /// Attempt to log in with the provided credentials
    func login() {
        // Clear previous errors
        errorMessage = ""
        isLoading = true
        
        // Simulate network delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let result = self.authService.login(email: self.email, password: self.password)
            
            switch result {
            case .success:
                self.isAuthenticated = true
                self.errorMessage = ""
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
            }
            
            self.isLoading = false
        }
    }
    
    /// Validate if the login form is complete
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
