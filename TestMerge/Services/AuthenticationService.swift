//
//  AuthenticationService.swift
//  AuthApp
//
//  Created by Antigravity
//

import Foundation
import Combine

/// Service responsible for handling user authentication and session management
class AuthenticationService: ObservableObject {
    /// Shared singleton instance
    static let shared = AuthenticationService()
    
    /// Currently authenticated user
    @Published var currentUser: User?
    
    /// Whether a user is currently authenticated
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    private let userDefaultsKey = "com.authapp.users"
    private let currentUserKey = "com.authapp.currentUser"
    
    private init() {
        loadCurrentUser()
    }
    
    // MARK: - Authentication Methods
    
    /// Attempt to log in with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Result containing the authenticated user or an error
    func login(email: String, password: String) -> Result<User, AuthError> {
        // Validate input
        guard !email.isEmpty else {
            return .failure(.emptyEmail)
        }
        
        guard !password.isEmpty else {
            return .failure(.emptyPassword)
        }
        
        guard isValidEmail(email) else {
            return .failure(.invalidEmail)
        }
        
        // Load stored users
        let users = loadUsers()
        
        // Find user with matching email
        guard let user = users.first(where: { $0.email.lowercased() == email.lowercased() }) else {
            return .failure(.userNotFound)
        }
        
        // Verify password (simple hash comparison for demo)
        let passwordHash = hashPassword(password)
        guard user.passwordHash == passwordHash else {
            return .failure(.incorrectPassword)
        }
        
        // Set current user
        currentUser = user
        saveCurrentUser(user)
        
        return .success(user)
    }
    
    /// Create a new user account
    /// - Parameters:
    ///   - name: User's full name
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Result containing the created user or an error
    func signup(name: String, email: String, password: String) -> Result<User, AuthError> {
        // Validate input
        guard !name.isEmpty else {
            return .failure(.emptyName)
        }
        
        guard !email.isEmpty else {
            return .failure(.emptyEmail)
        }
        
        guard !password.isEmpty else {
            return .failure(.emptyPassword)
        }
        
        guard isValidEmail(email) else {
            return .failure(.invalidEmail)
        }
        
        guard password.count >= 6 else {
            return .failure(.passwordTooShort)
        }
        
        // Load existing users
        var users = loadUsers()
        
        // Check if email already exists
        if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            return .failure(.emailAlreadyExists)
        }
        
        // Create new user
        let passwordHash = hashPassword(password)
        let newUser = User(name: name, email: email, passwordHash: passwordHash)
        
        // Save user
        users.append(newUser)
        saveUsers(users)
        
        // Set as current user
        currentUser = newUser
        saveCurrentUser(newUser)
        
        return .success(newUser)
    }
    
    /// Log out the current user
    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    // MARK: - Private Helper Methods
    
    /// Validate email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Simple password hashing (for demo purposes only - use proper hashing in production)
    private func hashPassword(_ password: String) -> String {
        return password.data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    /// Load all users from UserDefaults
    private func loadUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
    
    /// Save users to UserDefaults
    private func saveUsers(_ users: [User]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    /// Load current user from UserDefaults
    private func loadCurrentUser() {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return
        }
        currentUser = user
    }
    
    /// Save current user to UserDefaults
    private func saveCurrentUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: currentUserKey)
        }
    }
}

// MARK: - Authentication Errors

/// Errors that can occur during authentication
enum AuthError: LocalizedError {
    case emptyName
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case passwordTooShort
    case emailAlreadyExists
    case userNotFound
    case incorrectPassword
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Please enter your name"
        case .emptyEmail:
            return "Please enter your email address"
        case .emptyPassword:
            return "Please enter your password"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .passwordTooShort:
            return "Password must be at least 6 characters"
        case .emailAlreadyExists:
            return "An account with this email already exists"
        case .userNotFound:
            return "No account found with this email"
        case .incorrectPassword:
            return "Incorrect password"
        }
    }
}
