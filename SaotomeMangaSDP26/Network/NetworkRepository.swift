//
//  NetworkRepository.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 3/1/26.
//

import Foundation
import NetworkAPI

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
}
