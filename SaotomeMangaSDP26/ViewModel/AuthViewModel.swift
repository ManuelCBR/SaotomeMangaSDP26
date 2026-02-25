//
//  AuthViewModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 22/2/26.
//

import Foundation
import NetworkAPI

@Observable
@MainActor
final class AuthViewModel {
    // MARK: - Estados
        
    /// ¿El usuario está autenticado?
    var isAuthenticated: Bool = false
    
    /// Usuario actual (nil si no está autenticado)
    var currentUser: User?
    
    /// ¿Estamos haciendo alguna operación? (login, register, etc.)
    var isLoading: Bool = false
    
    /// Mensaje de error para mostrar en la UI
    var errorMessage: String?
    
    // MARK: - Servicios privados
        
    /// Manager de Keychain para guardar/leer tokens
    private let keychain = KeychainManager.shared
    
    /// Clave para identificar el token en Keychain
    private let tokenKey = "authToken"
    
    /// NetworkRepository (para hacer peticiones)
     private let repository = NetworkRepository()
    
    // MARK: - Inicialización
    
    init() {
        // Al crear el ViewModel, verificamos si ya hay un token guardado
        checkAuthStatus()
    }
    
    // MARK: - Métodos públicos
       
   /// Verifica si hay un token guardado al abrir la app
    func checkAuthStatus() {
            print("🔍 AuthViewModel: Verificando estado de autenticación...")
            
        if keychain.read(tokenKey) != nil {
                print("✅ AuthViewModel: Token encontrado")
                isAuthenticated = true
                currentUser = User(id: "temp", email: "temp@test.com")
            } else {
                print("⚠️ AuthViewModel: No se encontró token")
                isAuthenticated = false
                currentUser = nil
            }
        }
    
    /// Registrar un nuevo usuario
    func register(email: String, password: String) async {
        print("📝 AuthViewModel: Iniciando registro...")
        
        // Validaciones básicas
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required"
            return
        }
        
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters"
            return
        }
        
        // Mostrar loading
        isLoading = true
        errorMessage = nil
        
        do {
            // Crear credenciales
            let credentials = RegisterCredentials(email: email, password: password)
            
            // Llamada REAL a la API
            try await repository.register(credentials)
            
            print("✅ AuthViewModel: Usuario registrado exitosamente")
            
            // Nota: NO autenticamos automáticamente
            // El usuario debe hacer login después
            
        } catch let error as NetworkError {
            // Manejar errores de red
            print("❌ AuthViewModel: Error en registro - \(error.errorDescription ?? "Unknown")")
            errorMessage = error.errorDescription ?? "Registration failed"
            
        } catch {
            // Otros errores
            print("❌ AuthViewModel: Error inesperado - \(error)")
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    /// Iniciar sesión
    func login(email: String, password: String) async {
        print("🔐 AuthViewModel: Iniciando login...")
        
        // Validaciones básicas
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required"
            return
        }
        
        // Mostrar loading
        isLoading = true
        errorMessage = nil
        
        do {
            // Crear credenciales
            let credentials = LoginCredentials(email: email, password: password)
            
            // Llamada REAL a la API
            let authResponse = try await repository.login(credentials)
            
            print("✅ AuthViewModel: Login exitoso, token recibido")
            
            // Guardar token en Keychain
            let saved = keychain.save(authResponse.token, for: tokenKey)
            
            if saved {
                print("✅ AuthViewModel: Token guardado en Keychain")
                
                // TODO: Decodificar el token JWT para obtener userId
                // Por ahora, creamos usuario con el email
                currentUser = User(id: "temp", email: email)
                
                // Marcar como autenticado
                isAuthenticated = true
                
                print("✅ AuthViewModel: Login completado")
                print("🔑 TOKEN: \(authResponse.token)")
            } else {
                errorMessage = "Failed to save authentication token"
                print("❌ AuthViewModel: Error al guardar token")
            }
            
        } catch let error as NetworkError {
            // Manejar errores de red
            print("❌ AuthViewModel: Error en login - \(error.errorDescription ?? "Unknown")")
            
            // Mensajes más amigables según el error
            switch error {
            case .status(401):
                errorMessage = "Invalid email or password"
            case .status(let code):
                errorMessage = "Server error (\(code))"
            default:
                errorMessage = error.errorDescription ?? "Login failed"
            }
            
        } catch {
            // Otros errores
            print("❌ AuthViewModel: Error inesperado - \(error)")
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    /// Cerrar sesión
    func logout() {
        print("🚪 AuthViewModel: Cerrando sesión...")
        
        // Borrar token del Keychain
        keychain.delete(tokenKey)
        
        // Limpiar estado
        isAuthenticated = false
        currentUser = nil
        errorMessage = nil
        
        print("✅ AuthViewModel: Logout completado")
    }
    
    /// Renovar token (útil al abrir la app si el token está próximo a expirar)
    func renewToken() async {
        print("🔄 AuthViewModel: Renovando token...")
        
        guard let currentToken = keychain.read(tokenKey) else {
            print("❌ AuthViewModel: No hay token para renovar")
            logout()
            return
        }
        
        isLoading = true
        
        do {
            // Llamada REAL a la API
            let authResponse = try await repository.renewAuthToken(currentToken)
            
            print("✅ AuthViewModel: Token renovado")
            
            // Guardar nuevo token
            let saved = keychain.save(authResponse.token, for: tokenKey)
            
            if saved {
                print("✅ AuthViewModel: Nuevo token guardado")
            } else {
                print("❌ AuthViewModel: Error crítico al guardar token renovado")
                logout()
            }
            
        } catch let error as NetworkError {
            print("❌ AuthViewModel: Error al renovar token - \(error.errorDescription ?? "Unknown")")
            
            // Si el token es inválido, hacer logout
            if case .status(401) = error {
                print("⚠️ AuthViewModel: Token inválido, cerrando sesión")
                logout()
            }
            
        } catch {
            print("❌ AuthViewModel: Error inesperado - \(error)")
            logout()
        }
        
        isLoading = false
    }
}
