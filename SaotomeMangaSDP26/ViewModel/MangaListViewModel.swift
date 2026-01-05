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
    var isLoadingMore = false  // Para distinguir carga inicial de carga de más páginas
    var errorMessage: String?
    
    private let repository: NetworkRepository
    private var currentPage = 0  // Empezamos en 0, la primera carga será página 1
    private var canLoadMore = true  // Flag para saber si hay más páginas disponibles
    
    init(repository: NetworkRepository = NetworkRepository()) {
        self.repository = repository
    }
    
    // Carga la primera página de mangas (reset completo)
    func loadMangas() async {
        // Si ya estamos cargando, no hacer nada
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = 0
        canLoadMore = true
        mangas = []  // Limpiamos la lista
        
        await fetchPage()
        
        isLoading = false
    }
    
    // Carga la siguiente página (para scroll infinito)
    func loadMoreIfNeeded(currentManga: Manga) async {
        // Verificamos si el manga actual es uno de los últimos 5
        guard let index = mangas.firstIndex(where: { $0.id == currentManga.id }),
              index >= mangas.count - 5 else {
            return
        }
        
        await loadMore()
    }
    
    // Carga más mangas (siguiente página)
    func loadMore() async {
        // Evitar cargas múltiples simultáneas
        guard !isLoading, !isLoadingMore, canLoadMore else { return }
        
        isLoadingMore = true
        errorMessage = nil
        
        await fetchPage()
        
        isLoadingMore = false
    }
    
    // Petición real a la API
    private func fetchPage() async {
        do {
            currentPage += 1
            
            let dto = try await repository.getMangas(page: currentPage)
            let newMangas = dto.map { $0.toManga() }
            
            // Si no vienen mangas, ya no hay más páginas
            if newMangas.isEmpty {
                canLoadMore = false
            } else {
                mangas.append(contentsOf: newMangas)
            }
            
        } catch {
            errorMessage = error.localizedDescription
            currentPage -= 1  // Revertimos el incremento si falló
        }
    }
}
