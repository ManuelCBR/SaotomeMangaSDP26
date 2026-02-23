//
//  AuthModels.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 22/2/26.
//

import Foundation

// MARK: - User

/// Representa un usuario autenticado en la aplicación
struct User: Codable, Identifiable {
    let id: String
    let email: String
}

// MARK: - Auth Response

/// Respuesta del servidor al hacer login o renovar token
struct AuthResponse: Codable {
    let token: String
}

// MARK: - Login Credentials

/// Credenciales para iniciar sesión
struct LoginCredentials: Codable {
    let email: String
    let password: String
}

// MARK: - Register Credentials

/// Datos para registrar un nuevo usuario
struct RegisterCredentials: Codable {
    let email: String
    let password: String
}
