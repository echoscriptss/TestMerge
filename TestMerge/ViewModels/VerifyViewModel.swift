//
//  VerifyViewModel.swift
//  TestMerge
//
//  Created by Mobile Programming on 16/01/26.
//

import Foundation
import Combine

/// ViewModel for the signup screen
class VerifyViewModel: ObservableObject {
  // MARK: - Published Properties
  
  /// User's name input
  @Published var name: String = ""
  
  /// User's email input
  @Published var email: String = ""
  
  /// User's password input
  @Published var password: String = ""
  
  /// User's password confirmation input
  @Published var confirmPassword: String = ""
}
