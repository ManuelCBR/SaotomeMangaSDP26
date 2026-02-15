//
//  MangaGridContent.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 15/2/26.
//

import SwiftUI

struct MangaGridContent: View {
    let mangas: [Manga]
    let isLoading: Bool
    let isLoadingMore: Bool
    let errorMessage: String?
    let onLoadMore: ((Manga) async -> Void)?
    
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectionViewModel
    @Environment(\.modelContext) private var modelContext

    let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 250), spacing: 16)
    ]
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = errorMessage, mangas.isEmpty {
                ContentUnavailableView(
                    "Error Loading",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
            } else if mangas.isEmpty {
                ContentUnavailableView(
                    "No results",
                    systemImage: "magnifyingglass",
                    description: Text("Try another filter or search")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(mangas) { manga in
                            NavigationLink(value: manga) {
                                MangaCard(manga: manga)
                            }
                            .buttonStyle(.plain)
                            .task {
                                if let onLoadMore {
                                    await onLoadMore(manga)
                                }
                                userMangaCollectionViewModel.setModelContext(modelContext)
                            }
                        }
                        
                        // Indicador de carga al final
                        if isLoadingMore {
                            GridRow {
                                VStack(spacing: 8) {
                                    ProgressView()
                                    Text("Loading more...")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .gridCellColumns(columns.count)
                            }
                        }
                    }
                    .padding()
                }
                .navigationDestination(for: Manga.self) { manga in
                    DetailView(manga: manga)
                }
            }
        }
    }
}

#Preview {
    MangaGridContent(mangas: [.test, .test], isLoading: false, isLoadingMore: false, errorMessage: "", onLoadMore: { _ in })
        .environment(UserMangaCollectionViewModel())
}
