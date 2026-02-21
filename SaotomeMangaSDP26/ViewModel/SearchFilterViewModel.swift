//
//  SearchFilterViewModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 17/1/26.
//

import Foundation

@Observable
@MainActor
final class SearchFilterViewModel {
    var availableGenres: [String] = []
    var availableDemographics: [String] = []
    var availableThemes: [String] = []
    var availableAuthors: [Author] = []
    
    var searchedAuthors: [Author] = []
    var isSearchingAuthors = false
    var authorSearchError: String?
    
    var isLoading = false
    var errorMessage: String?
    
    private let repository: NetworkRepository
    private var searchTask: Task<Void, Never>?
    
    init(repository: NetworkRepository = NetworkRepository()) {
        self.repository = repository
    }
    
    func loadFilters() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let genresTask = repository.getGenres()
            async let demographicsTask = repository.getDemographics()
            async let themesTask = repository.getThemes()
            async let authorsTask = repository.getAuthors()
            
            let (genres, demographics, themes, authorDTOs) = try await (
                genresTask,
                demographicsTask,
                themesTask,
                authorsTask
            )
            
            availableGenres = genres.sorted()
            availableDemographics = demographics.sorted()
            availableThemes = themes.sorted()
            availableAuthors = authorDTOs
                .map { $0.toAuthor() }
                .sorted { $0.lastName < $1.lastName }
        } catch {
            errorMessage = "Error loading filters: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func searchAuthors(query: String) async {
        // Cancelar búsqueda anterior si existe
        searchTask?.cancel()
        
        // Si el query está vacío, limpiar resultados
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchedAuthors = []
            authorSearchError = nil
            return
        }
        
        // Crear nueva tarea de búsqueda
        searchTask = Task {
            // Esperar 300ms antes de buscar
            try? await Task.sleep(for: .milliseconds(300))
            
            // Si la tarea fue cancelada, no continuar
            guard !Task.isCancelled else { return }
            
            isSearchingAuthors = true
            authorSearchError = nil
            
            do {
                let authorDTOs = try await repository.searchAuthor(query)
                
                // Verificar de nuevo si fue cancelada
                guard !Task.isCancelled else { return }
                
                // Mapear DTOs a modelos
                searchedAuthors = authorDTOs.map { $0.toAuthor() }
            } catch {
                guard !Task.isCancelled else { return }
                
                authorSearchError = error.localizedDescription
                searchedAuthors = []
            }
            isSearchingAuthors = false
        }
    }
}
