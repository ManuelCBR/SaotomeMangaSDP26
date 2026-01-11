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
        let response = try await getJSON(.get(url: .getMangas(page: page)), type: MangaResponseDTO.self)
        return response.items
    }
    
    func getManga(id: Int) async throws -> MangaDTO {
        let response = try await getJSON(.get(url: .getManga(id: id)), type: MangaResponseDTO.self)
        return response.items.first!
    }
    
    func getBestMangas() async throws -> [MangaDTO] {
        let response = try await getJSON(.get(url: .getBestMangas), type: MangaResponseDTO.self)
        return response.items
    }
    
    func getAuthors() async throws -> [AuthorDTO] {
        try await getJSON(.get(url: .getAuthors), type: [AuthorDTO].self)
    }
}
