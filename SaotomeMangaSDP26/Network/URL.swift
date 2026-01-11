//
//  URL.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 3/1/26.
//

import Foundation

let api: URL = {
    guard let url = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com") else {
        fatalError("Invalid API URL")
    }
    return url
}()

extension URL {
    // Endpoints de listados
    static let getMangas = api.appending(path: "/list/mangas")
    static let getBestMangas = api.appending(path: "/list/bestMangas")
    static let getAuthors = api.appending(path: "/list/authors")
    
    // Endpoint con paginación
    static func getMangas(page: Int) -> URL {
        let url = api.appending(path: "/list/mangas")
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "20")
        ]
        return url.appending(queryItems: queryItems)
    }
    
    static func getManga(id: Int) -> URL {
        api.appending(path: "/search/manga/\(id)")
    }
}
