//
//  MangaModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import Foundation
import SwiftData

@Model
final class Manga {
    #Index<Manga>([\.title])
    @Attribute(.unique) var id: Int
    
    var title: String
    var titleEnglish: String?
    var titleJapanese: String?
    
    // Información de publicación
    var startDate: String?
    var endDate: String?
    var status: String
    
    // Números y estadísticas
    var volumes: Int?
    var chapters: Int?
    var score: Double?
    
    // Textos descriptivos
    var sypnosis: String?
    var background: String?
    
    // URLs
    var mainPicture: URL?
    var url: URL?
    
    // Relaciones
    @Relationship var authors: [Author]
    @Relationship var genres: [Genres]
    @Relationship var themes: [Theme]
    @Relationship var demographics: [Demographics]
    
    init(id: Int, title: String, titleEnglish: String? = nil, titleJapanese: String? = nil, startDate: String? = nil, endDate: String? = nil, status: String, volumes: Int? = nil, chapters: Int? = nil, score: Double? = nil, sypnosis: String? = nil, background: String? = nil, mainPicture: URL? = nil, url: URL? = nil, authors: [Author], genres: [Genres], themes: [Theme], demographics: [Demographics]) {
        self.id = id
        self.title = title
        self.titleEnglish = titleEnglish
        self.titleJapanese = titleJapanese
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.volumes = volumes
        self.chapters = chapters
        self.score = score
        self.sypnosis = sypnosis
        self.background = background
        self.mainPicture = mainPicture
        self.url = url
        self.authors = authors
        self.genres = genres
        self.themes = themes
        self.demographics = demographics
    }
}
