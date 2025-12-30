//
//  ModelDTO.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import Foundation

struct AuthorDTO: Codable, Sendable {
    let id: String
    let firstName: String
    let lastName: String
    let role: String
    
    /// Computed property para obtener el nombre completo
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

// MARK: - DTO para Theme
/// Representa una temática del manga (ej: "Martial Arts", "Super Power")
struct ThemeDTO: Codable, Sendable {
    let id: String
    let theme: String
}

// MARK: - DTO para Demographic
/// Representa el público objetivo (ej: "Shounen", "Seinen")
struct DemographicDTO: Codable, Sendable {
    let id: String
    let demographic: String
}

// MARK: - DTO para Genre
/// Representa el género del manga (ej: "Action", "Comedy")
struct GenreDTO: Codable, Sendable {
    let id: String
    let genre: String
}

// MARK: - DTO principal para Manga
/// Este es el DTO completo que mapea toda la información de un manga
struct MangaDTO: Codable, Sendable, Identifiable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    
    // Información de publicación
    let startDate: String?
    let endDate: String?
    let status: String
    
    // Números y estadísticas
    let volumes: Int?
    let chapters: Int?
    let score: Double?
    
    // Textos descriptivos
    let sypnosis: String?
    let background: String?
    
    // URLs (vienen como String en el JSON, las convertiremos después)
    let mainPicture: String?
    let url: String?
    
    // Relaciones - la forma de casarlos es a través del UUID
    let authors: UUID
    let genres: UUID
    let themes: UUID
    let demographics: UUID
    
    /// Computed property para limpiar la URL de la imagen
    /// El JSON viene con comillas extras: "\"https://...\""
    /// Esta propiedad las elimina y devuelve una URL limpia
//    var cleanImageURL: URL? {
//        guard let mainPicture = mainPicture else { return nil }
//        let cleanString = mainPicture.replacingOccurrences(of: "\"", with: "")
//        return URL(string: cleanString)
//    }
}
