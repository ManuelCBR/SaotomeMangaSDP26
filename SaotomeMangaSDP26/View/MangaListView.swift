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
    
    var body: some View {
        @Bindable var userMangaCollectionViewModel = userMangaCollectionViewModel
        NavigationStack {
            Group {
                if mangaListViewModel.isLoading {
                    ProgressView("Loading...")
                } else if mangaListViewModel.errorMessage != nil {
                    ScrollView {
                        ContentUnavailableView(
                            "No mangas available",
                            image: "film",
                            description: Text("No mangas found available")
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .refreshable {
                        await mangaListViewModel.loadMangas()
                    }
                } else {
                    List {
                        ForEach(mangaListViewModel.mangas) { manga in
                            NavigationLink(value: manga) {
                                MangaRow(manga: manga)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button {
                                            userMangaCollectionViewModel.toggleCollection(manga)
                                        } label: {
                                            Image(systemName: userMangaCollectionViewModel.isInCollection(manga.id) ? "bookmark.fill" : "bookmark")
                                        }
                                    }
                            }
                            .task {
                                await mangaListViewModel.loadMoreIfNeeded(currentManga: manga)
                            }
                        }
                        
                        if mangaListViewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .navigationDestination(for: Manga.self) { manga in
                        DetailView(manga: manga)
                    }
                    .task {
                        userMangaCollectionViewModel.setModelContext(modelContext)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Mangas")
        }
        .task {
            await mangaListViewModel.loadMangas()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MangaListView()
        .environment(UserMangaCollectionViewModel())
        .environment(MangaListViewModel())
}
