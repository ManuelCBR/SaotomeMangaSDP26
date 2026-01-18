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
    private var dataSource: DataSource = .all // Fuente de datos actual
    
    // Flag para evitar cargas simultáneas
    private var isFetchingPage = false
    
    init(repository: NetworkRepository = NetworkRepository()) {
        self.repository = repository
    }
    
    // Carga la primera página de mangas (reset completo)
    func loadMangas(source: DataSource = .all) async {
        // Si ya estamos cargando, no hacer nada
        guard !isLoading else { return }
        
        dataSource = source
        
        isLoading = true
        errorMessage = nil
        currentPage = 0
        canLoadMore = true
        mangas = []  // Limpiamos la lista
        isFetchingPage = false
        
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
        guard !isLoading,
              !isLoadingMore,
              !isFetchingPage,
              canLoadMore else {
            return
        }
        
        isLoadingMore = true
        errorMessage = nil
        
        await fetchPage()
        
        isLoadingMore = false
    }
    
    // Petición real a la API
    private func fetchPage() async {
        // Evitar llamadas concurrentes
        guard !isFetchingPage else {
            return
        }
        
        isFetchingPage = true
        defer { isFetchingPage = false }
        
        do {
            currentPage += 1
            
            let mangaDTOs: [MangaDTO]
            
            switch dataSource {
            case .all:
                mangaDTOs = try await repository.getMangas(page: currentPage)
                
            case .bestMangas:
                mangaDTOs = try await repository.getBestMangas(page: currentPage)
                
            case .genre(let genre):
                mangaDTOs = try await repository.getMangasByGenre(genre, page: currentPage)
                
            case .demographic(let demographic):
                mangaDTOs = try await repository.getMangasByDemographic(demographic, page: currentPage)
                
            case .theme(let theme):
                mangaDTOs = try await repository.getMangasByTheme(theme, page: currentPage)
                
            case .author(let authorID, _):
                mangaDTOs = try await repository.getMangasByAuthor(authorID, page: currentPage)
                
            case .search(let query):
                mangaDTOs = try await repository.searchMangasContains(query, page: currentPage)
            }
            
            let newMangas = mangaDTOs.map { $0.toManga() }
            
            if newMangas.isEmpty {
                canLoadMore = false
            } else {
                mangas.append(contentsOf: newMangas)
            }
            
        } catch is CancellationError {
            // Manejo específico de cancelación por exceso de scroll
            currentPage -= 1
        } catch {
            currentPage -= 1
            
            if mangas.isEmpty {
                errorMessage = error.localizedDescription
                canLoadMore = false
            }
        }
    }
    func reset() {
        mangas = []
        currentPage = 0
        canLoadMore = true
        errorMessage = nil
        dataSource = .all
        isLoading = false
        isLoadingMore = false
        isFetchingPage = false
    }
}

enum DataSource: Hashable{
    case all
    case bestMangas
    case genre(String)
    case demographic(String)
    case theme(String)
    case author(authorID: String, authorName: String)
    case search(String)
    
    var title: String {
        switch self {
        case .all:
            return "All Mangas"
        case .bestMangas:
            return "Best Mangas"
        case .genre(let name):
            return name
        case .demographic(let name):
            return name
        case .theme(let name):
            return name
        case .author(_, let authorName):
            return authorName
        case .search(let query):
            return "Results for '\(query)'"
        }
    }
}
