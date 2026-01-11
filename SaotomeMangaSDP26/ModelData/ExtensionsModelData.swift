//
//  ExtensionsModelData.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 11/1/26.
//

import Foundation

extension UserMangaCollection {
    var scoreText: String {
        score.map { String(format: "%.2f", $0) } ?? "N/A"
    }
    
    func toManga() -> Manga {
        Manga(
            id: id,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            startDate: startDate,
            endDate: endDate,
            status: status,
            volumes: volumes,
            chapters: chapters,
            score: score,
            sypnosis: sypnosis,
            background: background,
            mainPicture: URL(string: mainPicture ?? ""),
            url: URL(string: url ?? ""),
            authors: authors.map {
                // Como solo tenemos el nombre completo como String,
                // lo dividimos en firstName y lastName (simple)
                let components = $0.split(separator: " ")
                return Author(
                    id: UUID(),
                    firstName: components.first.map(String.init) ?? $0,
                    lastName: components.dropFirst().joined(separator: " "),
                    role: ""
                )
            },
            genres: genres.map {
                Genre(id: UUID(), genre: $0)
            },
            themes: themes.map {
                Theme(id: UUID(), theme: $0)
            },
            demographics: demographics.map {
                Demographic(id: UUID(), demographic: $0)
            }
        )
    }
}
