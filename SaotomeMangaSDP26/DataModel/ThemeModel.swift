//
//  ThemeModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import Foundation
import SwiftData

@Model
final class Theme {
    var id: UUID
    var theme: String
    
    @Relationship(deleteRule: .nullify, inverse: \Manga.themes)
        var mangas: [Manga]
    
    init(id: UUID, theme: String) {
        self.id = id
        self.theme = theme
        self.mangas = []
    }
}
