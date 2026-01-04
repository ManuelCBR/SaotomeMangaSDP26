//
//  MangaListViewModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 4/1/26.
//

import Foundation

@Observable @MainActor
final class MangaListViewModel {
    
    var mangas: [Manga] = []
    var isLoading = false
    var errorMessage: String?
    
    private let repository: NetworkRepository
    
    init(repository: NetworkRepository = NetworkRepository()) {
        self.repository = repository
    }
    
    func loadMangas() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let dto = try await repository.getMangas(page: 1)
            mangas = dto.map { $0.toManga() }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
