//
//  PreviewData.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 30/12/25.
//

import Foundation

import Foundation

// MARK: - Demographics

extension Demographics {
    @MainActor static let shounen = Demographics(id: UUID(), demographics: "Shounen")
    @MainActor static let seinen = Demographics(id: UUID(), demographics: "Seinen")
    @MainActor static let shojo = Demographics(id: UUID(), demographics: "Shojo")
    
    @MainActor static let sampleDemographics: [Demographics] = [
        shounen,
        seinen,
        shojo
    ]
}

// MARK: - Genres

extension Genres {
    @MainActor static let action = Genres(id: UUID(), genre: "Action")
    @MainActor static let fantasy = Genres(id: UUID(), genre: "Fantasy")
    @MainActor static let romance = Genres(id: UUID(), genre: "Romance")
    @MainActor static let drama = Genres(id: UUID(), genre: "Drama")
    @MainActor static let sciFi = Genres(id: UUID(), genre: "Sci-Fi")
    
    @MainActor static let sampleGenres: [Genres] = [
        action,
        fantasy,
        romance,
        drama,
        sciFi
    ]
}

// MARK: - Themes

extension Theme {
    @MainActor static let adventure = Theme(id: UUID(), theme: "Adventure")
    @MainActor static let supernatural = Theme(id: UUID(), theme: "Supernatural")
    @MainActor static let schoolLife = Theme(id: UUID(), theme: "School Life")
    @MainActor static let romanceTriangle = Theme(id: UUID(), theme: "Romance Triangle")
    
    @MainActor static let sampleThemes: [Theme] = [adventure, supernatural, schoolLife, romanceTriangle]
}

// MARK: - Authors

extension Author {
    @MainActor static let kiraTakahashi = Author(id: UUID(), firstName: "Kira", lastName: "Takahashi", role: "Mangaka")
    @MainActor static let renHayashi = Author(id: UUID(), firstName: "Ren", lastName: "Hayashi", role: "Story & Art")
    @MainActor static let minaIshida = Author(id: UUID(), firstName: "Mina", lastName: "Ishida", role: "Writer")
    
    @MainActor static let sampleAuthors: [Author] = [
        kiraTakahashi,
        renHayashi,
        minaIshida
    ]
}

// MARK: - Manga

extension Manga {
    // KiraTakahashi
    @MainActor static let bladeSaga = Manga(
        id: 1001,
        title: "Blade Saga",
        titleEnglish: "Blade Saga",
        titleJapanese: "ブレイドサーガ",
        startDate: "2021-04-10",
        endDate: nil,
        status: "Ongoing",
        volumes: 9,
        chapters: 85,
        score: 8.7,
        sypnosis: "En un mundo fracturado por reinos y sombras, un joven aprendiz de espada descubre un poder millenario.",
        background: "Inspirado en fantasía épica con combates intensos y relaciones profundas.",
        mainPicture: URL(string: "https://example.com/images/blade_saga.jpg"),
        url: URL(string: "https://example.com/manga/blade_saga"),
        authors: [.kiraTakahashi],
        genres: [.action, .fantasy],
        themes: [.adventure, .supernatural],
        demographics: [.shounen]
    )
    
    @MainActor static let starChronicles = Manga(
        id: 1002,
        title: "Star Chronicles",
        titleEnglish: "Star Chronicles",
        titleJapanese: "スタークロニクルズ",
        startDate: "2022-08-14",
        endDate: nil,
        status: "Ongoing",
        volumes: 5,
        chapters: 46,
        score: 8.3,
        sypnosis: "Una tripulación de marginados viaja por galaxias enfrentando misterios alienígenas y su propio pasado.",
        background: "Combina acción espacial con dilemas éticos y tecnología futurista.",
        mainPicture: URL(string: "https://example.com/images/star_chronicles.jpg"),
        url: URL(string: "https://example.com/manga/star_chronicles"),
        authors: [.kiraTakahashi],
        genres: [.sciFi, .action],
        themes: [.adventure],
        demographics: [.seinen]
    )

    // RenHayashi
    @MainActor static let dreamSchoolChronicles = Manga(
        id: 2001,
        title: "Dream School Chronicles",
        titleEnglish: "Dream School Chronicles",
        titleJapanese: "ドリームスクールクロニクル",
        startDate: "2023-01-01",
        endDate: nil,
        status: "Ongoing",
        volumes: 3,
        chapters: 28,
        score: 7.9,
        sypnosis: "Una estudiante ingresa a una escuela legendaria donde sueños y realidad colisionan.",
        background: "Tramas sobrenaturales con toques de romance escolar.",
        mainPicture: URL(string: "https://example.com/images/dream_school.jpg"),
        url: URL(string: "https://example.com/manga/dream_school"),
        authors: [.renHayashi],
        genres: [.fantasy, .romance],
        themes: [.schoolLife, .supernatural],
        demographics: [.shojo]
    )

    @MainActor static let cityLightsRunners = Manga(
        id: 2002,
        title: "City Lights Runners",
        titleEnglish: "City Lights Runners",
        titleJapanese: "シティライトランナーズ",
        startDate: "2024-06-20",
        endDate: nil,
        status: "Ongoing",
        volumes: 4,
        chapters: 34,
        score: 8.1,
        sypnosis: "En una metrópolis nocturna, un grupo de mensajeros entrega más que paquetes: secretos que pueden cambiarlo todo.",
        background: "Thriller urbano con acción vertiginosa y vínculos entre personajes.",
        mainPicture: URL(string: "https://example.com/images/city_runners.jpg"),
        url: URL(string: "https://example.com/manga/city_runners"),
        authors: [.renHayashi],
        genres: [.action, .drama],
        themes: [.adventure],
        demographics: [.seinen]
    )

    // MinaIshida
    @MainActor static let roseOfMemories = Manga(
        id: 3001,
        title: "Rose of Memories",
        titleEnglish: "Rose of Memories",
        titleJapanese: "メモリーズのバラ",
        startDate: "2020-05-15",
        endDate: "2024-09-10",
        status: "Completed",
        volumes: 12,
        chapters: 102,
        score: 9.2,
        sypnosis: "Una historia de amor y promesas que desafía el tiempo.",
        background: "Bella narrativa romántica con giros dramáticos y recuerdos imborrables.",
        mainPicture: URL(string: "https://example.com/images/rose_memories.jpg"),
        url: URL(string: "https://example.com/manga/rose_memories"),
        authors: [.minaIshida],
        genres: [.romance, .drama],
        themes: [.romanceTriangle],
        demographics: [.shojo]
    )

    @MainActor static let truthOfLegends = Manga(
        id: 3002,
        title: "Truth of Legends",
        titleEnglish: "Truth of Legends",
        titleJapanese: "伝説の真実",
        startDate: "2021-11-11",
        endDate: nil,
        status: "Ongoing",
        volumes: 6,
        chapters: 58,
        score: 8.8,
        sypnosis: "En un mundo gobernado por antiguas deidades, una chica busca la verdad detrás de las leyendas.",
        background: "Combina fantasía épica con intriga política y destino personal.",
        mainPicture: URL(string: "https://example.com/images/truth_legends.jpg"),
        url: URL(string: "https://example.com/manga/truth_legends"),
        authors: [.minaIshida],
        genres: [.fantasy, .action],
        themes: [.adventure, .supernatural],
        demographics: [.shounen]
    )
    
    @MainActor static let sampleManga: [Manga] = [
        bladeSaga,
        starChronicles,
        dreamSchoolChronicles,
        cityLightsRunners,
        roseOfMemories,
        truthOfLegends
    ]
}
