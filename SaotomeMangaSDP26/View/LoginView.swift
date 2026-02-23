//
//  LoginView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 22/2/26.
//

import SwiftUI

struct LoginView: View {
    // MARK: - ViewModel
    @Environment(AuthViewModel.self) private var authVM
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // MARK: - Estado local
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showRegister: Bool = false

    /// Validar que el formulario esté completo
    private var isFormValid: Bool {
        !email.isEmpty &&
        email.contains("@") &&
        password.count >= 8
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // MARK: - Header
                VStack() {
                    Image("SaotomeMangaPrincipal")
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .gray, radius: 8)
                        .frame(maxWidth: 400)
                    
                    Text("Sign in to your account")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top)
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
                                TextField("••••••••", text: $password)
                            } else {
                                SecureField("••••••••", text: $password)
                            }
                            
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .textContentType(.password)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
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
                
                // MARK: - Login Button
                Button {
                    Task {
                        await authVM.login(email: email, password: password)
                    }
                } label: {
                    if authVM.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Sign In")
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
                
                // MARK: - Register Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundStyle(.secondary)
                    
                    Button("Sign Up") {
                        showRegister = true
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.purple)
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: 600)
            .fullScreenCover(isPresented: $showRegister) {
                RegisterView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
