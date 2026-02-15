//
//  BestMangasView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 25/1/26.
//

import SwiftUI

struct BestMangasView: View {
    @State private var viewModel = MangaListViewModel()
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectionViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            Group{
                if horizontalSizeClass == .regular {
                    MangaGridContent(
                        mangas: viewModel.mangas,
                        isLoading: viewModel.isLoading,
                        isLoadingMore: viewModel.isLoadingMore,
                        errorMessage: viewModel.errorMessage,
                        onLoadMore: { manga in
                            await viewModel.loadMoreIfNeeded(currentManga: manga)
                        }
                    )
                } else {
                    MangaListContent(
                        mangas: viewModel.mangas,
                        isLoading: viewModel.isLoading,
                        isLoadingMore: viewModel.isLoadingMore,
                        errorMessage: viewModel.errorMessage,
                        onLoadMore: { manga in
                            await viewModel.loadMoreIfNeeded(currentManga: manga)
                        }
                    )
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Best Mangas")
        }
        .task {
            await viewModel.loadMangas(source: .bestMangas)
        }
    }
}

#Preview {
    BestMangasView()
        .environment(MangaListViewModel())
        .environment(UserMangaCollectionViewModel())
}
