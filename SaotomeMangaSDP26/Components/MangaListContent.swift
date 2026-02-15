//
//  MangaListContent.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

struct MangaListContent: View {
    let mangas: [Manga]
    let isLoading: Bool
    let isLoadingMore: Bool
    let errorMessage: String?
    let onLoadMore: ((Manga) async -> Void)?

    @Environment(UserMangaCollectionViewModel.self)
    var userMangaCollectionViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var userMangaCollectionViewModel =
            userMangaCollectionViewModel

        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if let error = errorMessage {
                ContentUnavailableView(
                    "No mangas available",
                    image: "film",
                    description: Text(error)
                )
            } else if mangas.isEmpty {
                ContentUnavailableView(
                    "No results",
                    systemImage: "magnifyingglass",
                    description: Text("Try another filter")
                )
            } else {
                List {
                    ForEach(mangas) { manga in
                        NavigationLink(value: manga) {
                            MangaRow(manga: manga)
                                .swipeActions(
                                    edge: .trailing,
                                    allowsFullSwipe: true
                                ) {
                                    Button {
                                        userMangaCollectionViewModel
                                            .toggleCollection(manga)
                                    } label: {
                                        Image(
                                            systemName:
                                                userMangaCollectionViewModel
                                                .isInCollection(manga.id)
                                                ? "bookmark.fill" : "bookmark"
                                        )
                                    }
                                }
                        }
                        .task {
                            if let onLoadMore {
                                await onLoadMore(manga)
                            }
                            userMangaCollectionViewModel.setModelContext(modelContext)
                        }
                    }

                    if isLoadingMore {
                       HStack {
                           Spacer()
                           VStack(spacing: 8) {
                               ProgressView()
                               Text("Loading more...")
                                   .font(.caption)
                                   .foregroundStyle(.secondary)
                           }
                           .padding()
                           Spacer()
                       }
                       .listRowSeparator(.hidden)
                   }
                }
                .navigationDestination(for: Manga.self) { manga in
                    DetailView(manga: manga)
                }
                .listStyle(.plain)
            }
        }
    }
}

