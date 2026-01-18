//
//  SearchView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchFilterViewModel = SearchFilterViewModel()
    @State private var mangaListViewModel = MangaListViewModel()
    @State private var searchText = ""
    @State private var showAllGenres = false
    @State private var showAllDemographics = false
    @State private var showAllThemes = false
    @State private var showAllAuthors = false
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if !searchText.isEmpty {
                    // Resultados de búsqueda de mangas por título
                    MangaListContent(
                        mangas: mangaListViewModel.mangas,
                        isLoading: mangaListViewModel.isLoading,
                        isLoadingMore: mangaListViewModel.isLoadingMore,
                        errorMessage: mangaListViewModel.errorMessage,
                        onLoadMore: { manga in
                            await mangaListViewModel.loadMoreIfNeeded(currentManga: manga)
                        }
                    )
                    .task(id: searchText) {
                        await mangaListViewModel.loadMangas(source: .search(searchText))
                    }
                } else {
                    // Grid de categorías con 4 elementos cada una
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // SECCIÓN: Géneros (Grid 2x2)
                            FilterSection(
                                title: "Genres",
                                systemImage: "circle.hexagonpath.fill",
                                items: searchFilterViewModel.availableGenres,
                                isLoading: searchFilterViewModel.isLoading,
                                showAll: $showAllGenres,
                                dataSourceBuilder: { .genre($0) }
                            )
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // SECCIÓN: Demografías (Grid 2x2)
                            FilterSection(
                                title: "Demographics",
                                systemImage: "globe.europe.africa.fill",
                                items: searchFilterViewModel.availableDemographics,
                                isLoading: searchFilterViewModel.isLoading,
                                showAll: $showAllDemographics,
                                dataSourceBuilder: { .demographic($0) }
                            )
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // SECCIÓN: Temas (Grid 2x2)
                            FilterSection(
                                title: "Themes",
                                systemImage: "text.bubble",
                                items: searchFilterViewModel.availableThemes,
                                isLoading: searchFilterViewModel.isLoading,
                                showAll: $showAllThemes,
                                dataSourceBuilder: { .theme($0) }
                            )
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // SECCIÓN: Autores (Grid 2x2 - pero sin cargar)
                            AuthorGridSection(showAll: $showAllAuthors)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Search")
            .navigationDestination(for: DataSource.self) { dataSource in
                FilteredMangaListView(dataSource: dataSource)
            }
            .searchable(
                text: $searchText,
                placement: .toolbarPrincipal,
                prompt: "Search manga title..."
            )
            .sheet(isPresented: $showAllGenres) {
                FiltersGridView(
                    title: "All Genres",
                    items: searchFilterViewModel.availableGenres,
                    dataSourceBuilder: { .genre($0) }
                )
            }
            .sheet(isPresented: $showAllDemographics) {
                FiltersGridView(
                    title: "All Demographics",
                    items: searchFilterViewModel.availableDemographics,
                    dataSourceBuilder: { .demographic($0) }
                )
            }
            .sheet(isPresented: $showAllThemes) {
                FiltersGridView(
                    title: "All Themes",
                    items: searchFilterViewModel.availableThemes,
                    dataSourceBuilder: { .theme($0) }
                )
            }
            .sheet(isPresented: $showAllAuthors) {
                AuthorSearchView(viewModel: searchFilterViewModel)
            }
        }
        .task {
            await searchFilterViewModel.loadFilters()
        }
    }
}

#Preview {
    SearchView()
}
