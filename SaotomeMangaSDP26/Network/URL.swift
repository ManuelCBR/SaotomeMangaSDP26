//
//  URL.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 3/1/26.
//

import Foundation

let api: URL = {
    guard let url = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com") else {
        fatalError("Invalid API URL")
    }
    return url
}()

/// Token de la app requerido para registro
let appToken = "sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY"

extension URL {
    // MARK: - Endpoints de listados
    static let getMangas = api.appending(path: "/list/mangas")
    static let getBestMangas = api.appending(path: "/list/bestMangas")
    static let getAuthors = api.appending(path: "/list/authors")
    
    // MARK: - Endpoints para obtener opciones de filtro
    static let getGenres = api.appending(path: "/list/genres")
    static let getDemographics = api.appending(path: "/list/demographics")
    static let getThemes = api.appending(path: "/list/themes")
    
    // MARK: - Authentication Endpoints
    
    static let registerUser = api.appending(path: "/users") /// Registrar nuevo usuario
    static let loginUser = api.appending(path: "/users/login") /// Login de usuario
    static let renewToken = api.appending(path: "/users/renew") /// Renovar token
    
    // MARK: - Endpoint con paginación
    // Mangas
    static func getMangas(page: Int) -> URL {
        let url = api.appending(path: "/list/mangas")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "20")
        ]
        return url.appending(queryItems: queryItems)
    }
    // Mejores Mangas
    static func getBestMangas(page: Int) -> URL {
        let url = api.appending(path: "/list/bestMangas")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "20")
        ]
        return url.appending(queryItems: queryItems)
    }
    // Por ID
    static func getManga(id: Int) -> URL {
        api.appending(path: "/search/manga/\(id)")
    }
    
    //Por género
    static func getMangasByGenre(_ genre: String, page: Int = 1) -> URL {
        let url = api.appending(path: "/list/mangaByGenre/\(genre.lowercased())")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "20")
        ]
        return url.appending(queryItems: queryItems)
    }
    
    // Por demografía
    static func getMangasByDemographic(_ demographic: String, page: Int = 1) -> URL {
        let url = api.appending(path: "/list/mangaByDemographic/\(demographic.lowercased())")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "20")
        ]
        return url.appending(queryItems: queryItems)
    }
    
    // Por tema
    static func getMangasByTheme(_ theme: String, page: Int = 1) -> URL {
        let url = api.appending(path: "/list/mangaByTheme/\(theme.lowercased())")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "20")
        ]
        return url.appending(queryItems: queryItems)
    }
    
    // Por autor
    static func getMangasByAuthor(_ authorID: String, page: Int = 1) -> URL {
        let url = api.appending(path: "/list/mangaByAuthor/\(authorID)")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "20")
        ]
        return url.appending(queryItems: queryItems)
    }
    
    // MARK: - Endpoints para obtener opciones de búsqueda
    // Empieza por...
    static func searchMangasBeginsWith(_ search: String, page: Int = 1) -> URL {
        let url = api.appending(path: "/search/mangasBeginsWith/\(search)")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "30")
        ]
        return url.appending(queryItems: queryItems)
    }
    
    // Contiene...
    static func searchMangasContains(_ search: String, page: Int = 1) -> URL {
        let url = api.appending(path: "/search/mangasContains/\(search)")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "30")
        ]
        return url.appending(queryItems: queryItems)
    }
    
    //Autor por nombre
    static func searchAuthor(_ search: String) -> URL {
        api.appending(path: "/search/author/\(search)")
    }
    
    // MARK: - Collection Endpoints

    /// Obtener toda la colección del usuario
    static let getUserCollection = api.appending(path: "/collection/manga")

    /// Añadir/actualizar manga en colección (mismo endpoint que GET, pero POST)
    static let addToCollection = api.appending(path: "/collection/manga")

    /// Obtener/eliminar manga específico de colección
    static func collectionManga(_ mangaId: Int) -> URL {
        api.appending(path: "/collection/manga/\(mangaId)")
    }
}
