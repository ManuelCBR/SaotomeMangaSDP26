//
//  ExtensionsDTO.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 4/1/26.
//

import Foundation

extension AuthorDTO {
    func toAuthor() -> Author {
        Author(
            id: UUID(uuidString: id) ?? UUID(),
            firstName: firstName,
            lastName: lastName,
            role: role
        )
    }
}

extension ThemeDTO {
    func toTheme() -> Theme {
        Theme(
            id: UUID(uuidString: id) ?? UUID(),
            theme: theme
        )
    }
}

extension DemographicDTO {
    func toDemographic() -> Demographic {
        Demographic(
            id: UUID(uuidString: id) ?? UUID(),
            demographic: demographic
        )
    }
}

extension GenreDTO {
    func toGenre() -> Genre {
        Genre(
            id: UUID(uuidString: id) ?? UUID(),
            genre: genre
        )
    }
}

extension MangaDTO {
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
            mainPicture: cleanImageURL,
            url: url.flatMap { URL(string: $0.replacingOccurrences(of: "\"", with: "")) },
            authors: authors.map { $0.toAuthor() },
            genres: genres.map { $0.toGenre() },
            themes: themes.map { $0.toTheme() },
            demographics: demographics.map { $0.toDemographic() }
        )
    }
}
