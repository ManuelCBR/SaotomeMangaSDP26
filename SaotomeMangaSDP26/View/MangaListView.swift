//
//  MangaListView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 8/1/26.
//

import SwiftUI

struct MangaListView: View {
    @Environment(MangaListViewModel.self) var mangaListViewModel
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectionViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            Group{
                if horizontalSizeClass == .regular {
                    MangaGridContent(
                        mangas: mangaListViewModel.mangas,
                        isLoading: mangaListViewModel.isLoading,
                        isLoadingMore: mangaListViewModel.isLoadingMore,
                        errorMessage: mangaListViewModel.errorMessage,
                        onLoadMore: { manga in
                            await mangaListViewModel.loadMoreIfNeeded(currentManga: manga)
                        }
                    )
                } else {
                    MangaListContent(
                        mangas: mangaListViewModel.mangas,
                        isLoading: mangaListViewModel.isLoading,
                        isLoadingMore: mangaListViewModel.isLoadingMore,
                        errorMessage: mangaListViewModel.errorMessage,
                        onLoadMore: { manga in
                            await mangaListViewModel.loadMoreIfNeeded(currentManga: manga)
                        }
                    )
                }
            }
            .navigationTitle("Mangas")
            .preferredColorScheme(.dark)
        }
        .task {
            await mangaListViewModel.loadMangas()
        }
    }
}

#Preview {
    MangaListView()
        .environment(UserMangaCollectionViewModel())
        .environment(MangaListViewModel())
}
