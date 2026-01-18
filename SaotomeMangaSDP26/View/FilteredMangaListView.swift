//
//  FilteredMangaListView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 17/1/26.
//

import SwiftUI

import SwiftUI

struct FilteredMangaListView: View {
    @State private var viewModel = MangaListViewModel()
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectionViewModel
    
    let dataSource: DataSource
    
    var body: some View {
        MangaListContent(
            mangas: viewModel.mangas,
            isLoading: viewModel.isLoading,
            isLoadingMore: viewModel.isLoadingMore,
            errorMessage: viewModel.errorMessage,
            onLoadMore: { manga in
                await viewModel.loadMoreIfNeeded(currentManga: manga)
            }
        )
        .navigationTitle(dataSource.title)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadMangas(source: dataSource)
        }
    }
}

#Preview {
    NavigationStack {
        FilteredMangaListView(dataSource: .genre("Fantasy"))
            .environment(UserMangaCollectionViewModel())
    }
}
