//
//  User.swift
//  AuthApp
//
//  Created by Antigravity
//

import Foundation

/// Represents a user in the authentication system
struct User: Identifiable, Codable, Equatable {
    /// Unique identifier for the user
    let id: UUID
    
    /// User's full name
    var name: String
    
    /// User's email address
    var email: String
    
    /// Hashed password (in production, never store plain passwords)
    var passwordHash: String
    
    /// Date when the user account was created
    let createdAt: Date
    
    /// Initialize a new user
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - name: User's full name
    ///   - email: User's email address
    ///   - passwordHash: Hashed password
    ///   - createdAt: Account creation date (defaults to now)
    init(id: UUID = UUID(), name: String, email: String, passwordHash: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = createdAt
    }
}
