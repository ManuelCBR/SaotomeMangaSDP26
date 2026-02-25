//
//  UserCollectionDTO.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 23/2/26.
//

import Foundation

// MARK: - Request (para POST)

/// Estructura para crear/actualizar un manga en la colección
struct CreateCollectionItemRequest: Codable {
    let volumesOwned: [Int]
    let completeCollection: Bool
    let readingVolume: Int
    let manga: Int
}

// MARK: - Response (lo que devuelve GET)

/// Item de la colección tal como viene de la API
struct UserCollectionItemDTO: Codable {
    let id: String
    let volumesOwned: [Int]
    let completeCollection: Bool
    let readingVolume: Int
    let manga: MangaDTO
}

// MARK: - Extensiones de conversión

extension UserCollectionItemDTO {
    /// Convierte el DTO de la API a UserMangaCollection (modelo local)
    func toUserMangaCollection() -> UserMangaCollection {
        let mangaModel = manga.toManga()
        let userCollection = UserMangaCollection(from: mangaModel)
        
        userCollection.volumesOwned = volumesOwned.count
        userCollection.readingVolume = readingVolume
        userCollection.hasCompleteCollection = completeCollection
        
        return userCollection
    }
}

extension UserMangaCollection {
    /// Convierte UserMangaCollection a CreateCollectionItemRequest (para POST)
    func toCreateRequest() -> CreateCollectionItemRequest {
        let volumesArray = volumesOwned > 0 ? Array(1...volumesOwned) : []
        
        return CreateCollectionItemRequest(
            volumesOwned: volumesArray,
            completeCollection: hasCompleteCollection,
            readingVolume: readingVolume,
            manga: id
        )
    }
}
