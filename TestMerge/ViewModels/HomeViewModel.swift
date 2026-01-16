//
//  HomeViewModel.swift
//  TestMerge
//
//  Created by Mobile Programming on 16/01/26.
//

import Foundation
import Combine

/// ViewModel for the login screen
class HomeViewModel: ObservableObject {
  
  // MARK: - Published Properties
  
  /// User's email input
  @Published var email: String = ""
  
  /// User's password input ass
  @Published var password: String = ""
}
