//
//  SignupViewModel.swift
//  AuthApp
//
//  Created by Antigravity
//

import Foundation
import Combine

/// ViewModel for the signup screen
class SignupViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// User's name input
    @Published var name: String = ""
    
    /// User's email input
    @Published var email: String = ""
    
    /// User's password input
    @Published var password: String = ""
    
    /// User's password confirmation input
    @Published var confirmPassword: String = ""
    
    /// Error message to display to the user
    @Published var errorMessage: String = ""
    
    /// Whether a signup request is in progress
    @Published var isLoading: Bool = false
    
    /// Whether signup was successful
    @Published var isAuthenticated: Bool = false
    
    private let authService = AuthenticationService.shared
    
    // MARK: - Methods
    
    /// Attempt to create a new account with the provided information
    func signup() {
        // Clear previous errors
        errorMessage = ""
        
        // Validate password match
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        
        // Simulate network delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let result = self.authService.signup(name: self.name, email: self.email, password: self.password)
            
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
    
    /// Validate if the signup form is complete
    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    /// Check if passwords match
    var passwordsMatch: Bool {
        password == confirmPassword && !confirmPassword.isEmpty
    }
}
