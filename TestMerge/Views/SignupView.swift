//
//  SignupView.swift
//  AuthApp
//
//  Created by Antigravity
//

import SwiftUI

/// Modern signup view with beautiful gradient design
struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel()
    @FocusState private var focusedField: Field?
    @Environment(\.presentationMode) var presentationMode
    
    enum Field {
        case name, email, password, confirmPassword
    }
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.5, blue: 0.9),
                    Color(red: 0.3, green: 0.2, blue: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Logo/Title Section
                    VStack(spacing: 12) {
                        Image(systemName: "person.badge.plus.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Join us today")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 10)
                    
                    // Signup Form
                    VStack(spacing: 18) {
                        // Name Field
                        CustomTextField(
                            icon: "person.fill",
                            placeholder: "Full Name",
                            text: $viewModel.name,
                            isSecure: false
                        )
                        .focused($focusedField, equals: .name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        
                        // Email Field
                        CustomTextField(
                            icon: "envelope.fill",
                            placeholder: "Email",
                            text: $viewModel.email,
                            isSecure: false
                        )
                        .focused($focusedField, equals: .email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        
                        // Password Field
                        CustomTextField(
                            icon: "lock.fill",
                            placeholder: "Password",
                            text: $viewModel.password,
                            isSecure: true
                        )
                        .focused($focusedField, equals: .password)
                        
                        // Confirm Password Field
                        HStack(spacing: 15) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24)
                            
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .textFieldStyle(PlainTextFieldStyle())
                                .focused($focusedField, equals: .confirmPassword)
                            
                            if !viewModel.confirmPassword.isEmpty {
                                Image(systemName: viewModel.passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(viewModel.passwordsMatch ? .green : .red)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        // Password Requirements
                        if !viewModel.password.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: viewModel.password.count >= 6 ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.password.count >= 6 ? .green : .white.opacity(0.6))
                                    .font(.system(size: 14))
                                Text("At least 6 characters")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Error Message
                        if !viewModel.errorMessage.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 14))
                                Text(viewModel.errorMessage)
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.9))
                            )
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Signup Button
                        Button(action: {
                            focusedField = nil
                            viewModel.signup()
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Create Account")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.4, green: 0.7, blue: 0.3),
                                        Color(red: 0.2, green: 0.6, blue: 0.4)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.green.opacity(0.5), radius: 15, x: 0, y: 8)
                        }
                        .disabled(!viewModel.isFormValid || viewModel.isLoading)
                        .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isFormValid)
                        
                        // Back to Login Link
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Sign In")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .font(.system(size: 15))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            focusedField = nil
        }
    }
}

#Preview {
    SignupView()
}
