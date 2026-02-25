//
//  KeychainManager.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 22/2/26.
//

import Foundation
import Security

//@Manuel [QUITAR LOS PRINTS]
final class KeychainManager {
    
    // MARK: - Singleton
        
    /// Instancia compartida (solo hay una en toda la app)
    static let shared = KeychainManager()
    
    /// Constructor privado para evitar crear más instancias
    private init() {}
    
    // MARK: - Métodos públicos
        
    /// Guarda un String en el Keychain
    /// - Parameters:
    ///   - value: El valor a guardar (ej: el token)
    ///   - key: La llave para identificarlo (ej: "authToken")
    /// - Returns: true si se guardó correctamente, false si falló

    func save (_ value: String, for key: String) -> Bool {
        // Convertir el String a Data (datos binarios)
        guard let data = value.data(using: .utf8) else { return false }
        
        // Crear consulta (instrucciones para Keychain)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Tipo: contraseña genérica
            kSecAttrAccount as String: key, // Identificador único
            kSecValueData as String: data // Los datos a guardar        ]
        ]
        
        // Intentamos borrar si ya existe (para evitar duplicados)
        SecItemDelete(query as CFDictionary)
        
        // Guardar en Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Verificar si se guardó correctamente
        if status == errSecSuccess {
            return true
        } else {
            print("❌ KeychainManager: Error al guardar '\(key)'. Status: \(status)")
            return false
        }
    }
    
    /// Lee un String del Keychain
    /// - Parameter key: La llave del valor a leer
    /// - Returns: El valor guardado o nil si no existe
    func read(_ key: String) -> String? {
        // 1. Crear query para buscar
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true, // Queremos que nos devuelva los datos
            kSecMatchLimit as String: kSecMatchLimitOne // Solo el primer resultado
        ]
        
        // 2. Intentar leer de Keychain
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        // 3. Verificar si encontró algo
        guard status == errSecSuccess else {
            return nil
        }
        
        // 4. Convertir Data a String
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            print("❌ KeychainManager: No se pudo convertir Data a String")
            return nil
        }
        return value
    }
    
    /// Elimina un valor del Keychain
    /// - Parameter key: La llave del valor a eliminar
    /// - Returns: true si se eliminó correctamente, false si falló
    @discardableResult
    func delete(_ key: String) -> Bool {
        // Crear query para identificar qué borrar
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        // Borrar de Keychain
        let status = SecItemDelete(query as CFDictionary)
        
        // Verificar resultado
        if status == errSecSuccess {
            print("✅ KeychainManager: Eliminado '\(key)' correctamente")
            return true
        } else {
            print("❌ KeychainManager: Error al eliminar '\(key)'. Status: \(status)")
            return false
        }
    }
    
}
