//
//  DemographicsModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 30/12/25.
//

import Foundation
import SwiftData

@Model
final class Demographics {
    var id: UUID
    var demographics: String
    
    @Relationship(deleteRule: .nullify, inverse: \Manga.demographics)
        var mangas: [Manga]
    
    init(id: UUID, demographics: String) {
        self.id = id
        self.demographics = demographics
        self.mangas = []
    }
}
