//
//  NetworkRepository.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 3/1/26.
//

import Foundation
import NetworkAPI

//@manuel ELIMINAR LOS PRINTS
struct NetworkRepository: NetworkInteractor {
    func getMangas(page: Int) async throws -> [MangaDTO] {
        let response = try await getJSON(
            .get(url: .getMangas(page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func getManga(id: Int) async throws -> MangaDTO {
        let response = try await getJSON(
            .get(url: .getManga(id: id)),
            type: MangaResponseDTO.self
        )
        return response.items.first!
    }

    func getBestMangas(page: Int = 1) async throws -> [MangaDTO] {
        let response = try await getJSON(
            .get(url: .getBestMangas(page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func getAuthors() async throws -> [AuthorDTO] {
        try await getJSON(.get(url: .getAuthors), type: [AuthorDTO].self)
    }

    func getGenres() async throws -> [String] {
        try await getJSON(.get(url: .getGenres), type: [String].self)
    }

    func getDemographics() async throws -> [String] {
        try await getJSON(
            .get(url: .getDemographics),
            type: [String].self
        )
    }

    func getThemes() async throws -> [String] {
        try await getJSON(.get(url: .getThemes), type: [String].self)
    }

    func getMangasByGenre(_ genre: String, page: Int = 1) async throws
        -> [MangaDTO]
    {
        let response = try await getJSON(
            .get(url: .getMangasByGenre(genre, page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func getMangasByDemographic(_ demographic: String, page: Int = 1)
        async throws -> [MangaDTO]
    {
        let response = try await getJSON(
            .get(url: .getMangasByDemographic(demographic, page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func getMangasByTheme(_ theme: String, page: Int = 1) async throws
        -> [MangaDTO]
    {
        let response = try await getJSON(
            .get(url: .getMangasByTheme(theme, page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func getMangasByAuthor(_ authorID: String, page: Int = 1) async throws
        -> [MangaDTO]
    {
        let response = try await getJSON(
            .get(url: .getMangasByAuthor(authorID, page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func searchMangasContains(_ search: String, page: Int = 1) async throws
        -> [MangaDTO]
    {
        let response = try await getJSON(
            .get(url: .searchMangasContains(search, page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func searchMangasBeginsWith(_ search: String, page: Int = 1) async throws
        -> [MangaDTO]
    {
        let response = try await getJSON(
            .get(url: .searchMangasBeginsWith(search, page: page)),
            type: MangaResponseDTO.self
        )
        return response.items
    }

    func searchAuthor(_ search: String) async throws -> [AuthorDTO] {
        try await getJSON(
            .get(url: .searchAuthor(search)),
            type: [AuthorDTO].self
        )
    }
    
    // MARK: - Helper privado para obtener token
        
    /// Obtiene el token de autenticación del Keychain
    /// - Throws: NetworkError.dataNotValid si no hay token
    private func getAuthToken() throws -> String {
        guard let token = KeychainManager.shared.read("authToken") else {
            throw NetworkError.dataNotValid
        }
        return token
    }
    
    // MARK: - Authentication Methods

    /// Registrar un nuevo usuario
    /// - Parameters:
    ///   - credentials: Email y password del usuario
    /// - Returns: Void (el servidor solo devuelve 201 Created)
    func register(_ credentials: RegisterCredentials) async throws {
        // Crear la request
        var request = URLRequest(url: .registerUser)
        request.httpMethod = "POST"
        
        // Headers obligatorios
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(appToken, forHTTPHeaderField: "App-Token")
        
        // Body con las credenciales
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(credentials)
        } catch {
            throw NetworkError.json(error)
        }
        
        // Hacer la petición
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Verificar que sea HTTPURLResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTP
        }
        
        // Verificar status code 201 Created
        guard httpResponse.statusCode == 201 else {
            throw NetworkError.status(httpResponse.statusCode)
        }
        
        print("✅ NetworkRepository: Usuario registrado exitosamente")
    }
    
    /// Iniciar sesión
    /// - Parameters:
    ///   - credentials: Email y password del usuario
    /// - Returns: AuthResponse con el token JWT
    func login(_ credentials: LoginCredentials) async throws -> AuthResponse {
        // Crear credenciales en Base64
        let credentialsString = "\(credentials.email):\(credentials.password)"
        guard let credentialsData = credentialsString.data(using: .utf8) else {
            throw NetworkError.dataNotValid
        }
        let base64Credentials = credentialsData.base64EncodedString()
        
        // Crear la request
        var request = URLRequest(url: .loginUser)
        request.httpMethod = "POST"
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        // Hacer la petición
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verificar respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTP
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.status(httpResponse.statusCode)
        }
        
        // Decodificar el token
        let decoder = JSONDecoder()
        do {
            let authResponse = try decoder.decode(AuthResponse.self, from: data)
            print("✅ NetworkRepository: Login exitoso, token recibido")
            return authResponse
        } catch {
            throw NetworkError.json(error)
        }
    }
    
    /// Renovar token actual
    /// - Parameter currentToken: Token actual a renovar
    /// - Returns: AuthResponse con el nuevo token
    func renewAuthToken(_ currentToken: String) async throws -> AuthResponse {
        // Crear la request
        var request = URLRequest(url: .renewToken)
        request.httpMethod = "POST"
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(currentToken)", forHTTPHeaderField: "Authorization")
        
        // Hacer la petición
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verificar respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTP
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.status(httpResponse.statusCode)
        }
        
        // Decodificar el nuevo token
        let decoder = JSONDecoder()
        do {
            let authResponse = try decoder.decode(AuthResponse.self, from: data)
            print("✅ NetworkRepository: Token renovado exitosamente")
            return authResponse
        } catch {
            throw NetworkError.json(error)
        }
    }
    
    // MARK: - Collection Methods

    /// Obtener toda la colección del usuario
    /// - Returns: Array de items de la colección
    func getUserCollection() async throws -> [UserCollectionItemDTO] {
        // Obtener token
        let token = try getAuthToken()
        
        // Crear request
        var request = URLRequest(url: .getUserCollection)
        request.httpMethod = "GET"
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Hacer petición
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verificar respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTP
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.status(httpResponse.statusCode)
        }
        
        // Decodificar
        let decoder = JSONDecoder()
        do {
            let collectionItems = try decoder.decode([UserCollectionItemDTO].self, from: data)
            print("✅ NetworkRepository: Colección obtenida - \(collectionItems.count) items")
            return collectionItems
        } catch {
            throw NetworkError.json(error)
        }
    }
    
    /// Añadir o actualizar un manga en la colección
    /// - Parameter item: Datos del manga a añadir/actualizar
    func addToCollection(_ item: CreateCollectionItemRequest) async throws {
        // Obtener token
        let token = try getAuthToken()
        
        // Crear request
        var request = URLRequest(url: .addToCollection)
        request.httpMethod = "POST"
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Body
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(item)
        } catch {
            throw NetworkError.json(error)
        }
        
        // Hacer petición
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Verificar respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTP
        }
        
        // Puede ser 200 (actualizado) o 201 (creado)
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw NetworkError.status(httpResponse.statusCode)
        }
        
        print("✅ NetworkRepository: Manga añadido/actualizado en colección")
    }

    /// Obtener un manga específico de la colección
    /// - Parameter mangaId: ID del manga
    /// - Returns: Item de la colección
    func getCollectionManga(_ mangaId: Int) async throws -> UserCollectionItemDTO {
        // Obtener token
        let token = try getAuthToken()
        
        // Crear request
        var request = URLRequest(url: .collectionManga(mangaId))
        request.httpMethod = "GET"
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Hacer petición
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verificar respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTP
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.status(httpResponse.statusCode)
        }
        
        // Decodificar
        let decoder = JSONDecoder()
        do {
            let collectionItem = try decoder.decode(UserCollectionItemDTO.self, from: data)
            print("✅ NetworkRepository: Manga obtenido de colección - ID: \(mangaId)")
            return collectionItem
        } catch {
            throw NetworkError.json(error)
        }
    }

    /// Eliminar un manga de la colección
    /// - Parameter mangaId: ID del manga a eliminar
    func deleteFromCollection(_ mangaId: Int) async throws {
        // Obtener token
        let token = try getAuthToken()
        
        // Crear request
        var request = URLRequest(url: .collectionManga(mangaId))
        request.httpMethod = "DELETE"
        
        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Hacer petición
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Verificar respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.nonHTTP
        }
        
        // Puede ser 200 o 204 (No Content)
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 204 else {
            throw NetworkError.status(httpResponse.statusCode)
        }
        
        print("✅ NetworkRepository: Manga eliminado de colección - ID: \(mangaId)")
    }
}
