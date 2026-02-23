//
//  RegisterView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 22/2/26.
//

import SwiftUI

struct RegisterView: View {
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthViewModel.self) private var authVM
    
    // MARK: - Estado local
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showSuccessMessage: Bool = false

    private var isFormValid: Bool {
        !email.isEmpty &&
        email.contains("@") &&
        password.count >= 8 &&
        password == confirmPassword
    }
    
    private var passwordStrength: String {
        if password.count < 8 {
            return "Too short"
        } else if password.count < 12 {
            return "Good"
        } else {
            return "Strong"
        }
    }
    
    private var passwordStrengthColor: Color {
        if password.count < 8 {
            return .red
        } else if password.count < 12 {
            return .orange
        } else {
            return .green
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // MARK: - Header
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 100))
                        .foregroundStyle(.purple)
                    
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Join SaotomeManga today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // MARK: - Formulario
                VStack(spacing: 16) {
                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        TextField("your@email.com", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            if showPassword {
                                TextField("At least 8 characters", text: $password)
                            } else {
                                SecureField("At least 8 characters", text: $password)
                            }
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .textContentType(.newPassword)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        
                        // Indicador de password seguro
                        if !password.isEmpty {
                            Text(passwordStrength)
                                .font(.caption)
                                .foregroundStyle(passwordStrengthColor)
                        }
                    }
                    
                    // Confirmación de password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        SecureField("Re-enter password", text: $confirmPassword)
                            .textContentType(.newPassword)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        
                        // Confirmación de coincidencia en password
                        if !confirmPassword.isEmpty && password != confirmPassword {
                            Text("Passwords don't match")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Error message
                if let error = authVM.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }
                
                // MARK: - Success message
                if showSuccessMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Account created! You can now sign in.")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                    .padding()
                    .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                }
                
                // MARK: - Register Button
                Button {
                    Task {
                        await register()
                    }
                } label: {
                    if authVM.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(.purple)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .disabled(authVM.isLoading || !isFormValid)
                .opacity(isFormValid ? 1.0 : 0.5)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .frame(maxWidth: 600)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Methods
    
    private func register() async {
        await authVM.register(email: email, password: password)
        
        // Si no hay error, mostrar mensaje de éxito
        if authVM.errorMessage == nil {
            showSuccessMessage = true
            
            // Cerrar la vista después de 2 segundos
            try? await Task.sleep(for: .seconds(2))
            dismiss()
        }
    }
}

#Preview {
    RegisterView()
        .environment(AuthViewModel())
}
