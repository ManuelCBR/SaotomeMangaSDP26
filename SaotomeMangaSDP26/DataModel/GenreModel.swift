//
//  GenreModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 30/12/25.
//

import Foundation
import SwiftData

@Model
final class Genres{
    var id: UUID
    var genre: String
    
    @Relationship(deleteRule: .nullify, inverse: \Manga.genres)
        var mangas: [Manga]
    
    init(id: UUID, genre: String) {
        self.id = id
        self.genre = genre
        self.mangas = []
    }
}
