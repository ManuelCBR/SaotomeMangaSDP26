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
    
    /// Computed property para obtener el nombre completo
    var fullName: String {
        "\(firstName) \(lastName)"
    }
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
    
    var scoreText: String {
        score.map { String(format: "%.2f", $0) } ?? "N/A"
    }
    
    private func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    var startDateFormatted: String? {
        guard let date = parseDate(startDate) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    var endDateFormatted: String? {
        guard let date = parseDate(endDate) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

struct Metadata: Codable {
    let per: Int
    let page: Int
    let total: Int
}

extension Manga {
    static let test = Manga(
        id: 1,
        title: "Monster",
        titleEnglish: "Monster",
        titleJapanese: "MONSTER",
        startDate: "1994-12-05T00:00:00Z",//Date.now,//,
        endDate: "2001-12-20T00:00:00Z",//Date.now,//,
        status: "finished",
        volumes: 18,
        chapters: 162,
        score: 9.15,
        sypnosis: "Kenzou Tenma, a renowned Japanese neurosurgeon working in post-war Germany, faces a difficult choice: to operate on Johan Liebert, an orphan boy on the verge of death, or on the mayor of Düsseldorf. In the end, Tenma decides to gamble his reputation by saving Johan, effectively leaving the mayor for dead.\n\nAs a consequence of his actions, hospital director Heinemann strips Tenma of his position, and Heinemann's daughter Eva breaks off their engagement. Disgraced and shunned by his colleagues, Tenma loses all hope of a successful career—that is, until the mysterious killing of Heinemann gives him another chance.\n\nNine years later, Tenma is the head of the surgical department and close to becoming the director himself. Although all seems well for him at first, he soon becomes entangled in a chain of gruesome murders that have taken place throughout Germany. The culprit is a monster—the same one that Tenma saved on that fateful day nine years ago.\n\n[Written by MAL Rewrite]",
        background: "Monster won the Grand Prize at the 3rd annual Tezuka Osamu Cultural Prize in 1999, as well as the 46th Shogakukan Manga Award in the General category in 2000. The series was published in English by VIZ Media under the VIZ Signature imprint from February 21, 2006 to December 16, 2008, and again in 2-in-1 omnibuses (subtitled The Perfect Edition) from July 15, 2014 to July 19, 2016. The manga was also published in Brazilian Portuguese by Panini Comics/Planet Manga from June 2012 to April 2015, in Polish by Hanami from March 2014 to February 2017, in Spain by Planeta Cómic from June 16, 2009 to September 21, 2010, and in Argentina by LARP Editores.",
        mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/3/258224l.jpg"),
        url: URL(string: "https://myanimelist.net/manga/1/Monster"),
        authors: [
            Author(
                id: UUID(),
                firstName: "Naoki",
                lastName: "Urasawa",
                role: "Story & Art"
            )
        ],
        genres: [
            Genre(id: UUID(), genre: "Award Winning"),
            Genre(id: UUID(), genre: "Drama"),
            Genre(id: UUID(), genre: "Mystery")
        ],
        themes: [
            Theme(id: UUID(), theme: "Adult Cast"),
            Theme(id: UUID(), theme: "Psychological")
        ],
        demographics: [
            Demographic(id: UUID(), demographic: "Seinen")
        ]
    )
}

extension Author {
    static let test = Author(
        id: UUID(),
        firstName: "Naoki",
        lastName: "Urasawa",
        role: "Story & Art"
    )
}
