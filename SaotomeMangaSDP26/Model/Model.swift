//
//  Model.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 4/1/26.
//

import Foundation

struct Author: Identifiable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
    let role: String
}

struct Theme:Identifiable, Hashable {
    let id: UUID
    let theme: String
}

struct Demographic: Identifiable, Hashable {
    let id: UUID
    let demographic: String
}

struct Genre: Identifiable, Hashable {
    let id: UUID
    let genre: String
}

struct Manga: Identifiable, Hashable {
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
    
    // URLs
    let mainPicture: URL?
    let url: URL?
    
    let authors: [Author]
    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]
}

struct Metadata: Codable {
    let per: Int
    let page: Int
    let total: Int
}
