//
//  UserMangaCollection.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 7/1/26.
//

import Foundation
import SwiftData

@Model
final class UserMangaCollection {
    #Index<UserMangaCollection>([\.title])

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
    var mainPicture: String?
    var url: String?

    var authors: [String]
    var genres: [String]
    var themes: [String]
    var demographics: [String]

    // Datos extras de la colección del usuario
    var volumesOwned: Int = 0
    var readingVolume: Int = 0
    var hasCompleteCollection: Bool = false

    // Metadata
    var addedDate: Date = Date()

        init(from manga: Manga) {
            self.id = manga.id
            self.title = manga.title
            self.titleEnglish = manga.titleEnglish
            self.titleJapanese = manga.titleJapanese
            self.startDate = manga.startDate
            self.endDate = manga.endDate
            self.status = manga.status
            self.volumes = manga.volumes
            self.chapters = manga.chapters
            self.score = manga.score
            self.sypnosis = manga.sypnosis
            self.background = manga.background
            self.mainPicture = manga.mainPicture?.absoluteString
            self.url = manga.url?.absoluteString
            self.authors = manga.authors.map { "\($0.firstName) \($0.lastName)" }
            self.genres = manga.genres.map { $0.genre }
            self.themes = manga.themes.map { $0.theme }
            self.demographics = manga.demographics.map { $0.demographic }
    
        }
}
