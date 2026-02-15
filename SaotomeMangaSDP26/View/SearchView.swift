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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                            
                            // SECCIÓN: Géneros
                            FilterSection(
                                title: "Genres",
                                systemImage: "circle.hexagonpath.fill",
                                items: searchFilterViewModel.availableGenres,
                                isLoading: searchFilterViewModel.isLoading,
                                sectionType: .genre,
                                showAll: $showAllGenres,
                                dataSourceBuilder: { .genre($0) }
                            )
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // SECCIÓN: Demografías
                            FilterSection(
                                title: "Demographics",
                                systemImage: "globe.europe.africa.fill",
                                items: searchFilterViewModel.availableDemographics,
                                isLoading: searchFilterViewModel.isLoading,
                                sectionType: .demographic,
                                showAll: $showAllDemographics,
                                dataSourceBuilder: { .demographic($0) }
                            )
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // SECCIÓN: Temas
                            FilterSection(
                                title: "Themes",
                                systemImage: "text.bubble",
                                items: searchFilterViewModel.availableThemes,
                                isLoading: searchFilterViewModel.isLoading,
                                sectionType: .theme,
                                showAll: $showAllThemes,
                                dataSourceBuilder: { .theme($0) }
                            )
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // SECCIÓN: Autores
                            AuthorGridSection(
                                authors: searchFilterViewModel.availableAuthors,
                                isLoading: searchFilterViewModel.isLoading,
                                showAll: $showAllAuthors
                            )
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
            .fullScreenCover(isPresented: $showAllGenres) {
                FiltersGridView(
                    title: "All Genres",
                    items: searchFilterViewModel.availableGenres,
                    sectionType: .genre,
                    dataSourceBuilder: { .genre($0) }
                )
            }
            .fullScreenCover(isPresented: $showAllDemographics) {
                FiltersGridView(
                    title: "All Demographics",
                    items: searchFilterViewModel.availableDemographics,
                    sectionType: .demographic,
                    dataSourceBuilder: { .demographic($0) }
                )
            }
            .fullScreenCover(isPresented: $showAllThemes) {
                FiltersGridView(
                    title: "All Themes",
                    items: searchFilterViewModel.availableThemes,
                    sectionType: .theme,
                    dataSourceBuilder: { .theme($0) }
                )
            }
            .fullScreenCover(isPresented: $showAllAuthors) {
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
