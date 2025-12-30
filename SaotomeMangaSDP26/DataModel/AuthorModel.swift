//
//  AuthorModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import Foundation
import SwiftData

@Model
final class Author {
    #Unique<Author>([\.id])
    
    var id: UUID
    var firstName: String
    var lastName: String
    var role: String
    
    @Relationship(deleteRule: .nullify, inverse: \Manga.authors) var mangas: [Manga]
    
    init(id: UUID, firstName: String, lastName: String, role: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.mangas = []
    }
}

extension Author {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
