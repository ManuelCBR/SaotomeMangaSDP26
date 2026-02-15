//
//  UserMangaCollectionView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 7/1/26.
//

import SwiftUI
import SwiftData

struct UserMangaCollectionView: View {
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectionViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Query private var userMangaCollection: [UserMangaCollection]
    
    private var mangas: [Manga] {
        userMangaCollection.map { $0.toManga() }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if userMangaCollection.isEmpty {
                    ContentUnavailableView(
                        "Empty Collection",
                        systemImage: "bookmark.fill",
                        description: Text("Aún no has guardado ningún manga en tu colección")
                    )
                } else {
                    if horizontalSizeClass == .regular {
                        ScrollView {
                            LazyVGrid(
                                columns: [
                                    GridItem(.adaptive(minimum: 250, maximum: 250), spacing: 16)
                                ],
                                spacing: 16
                            ) {
                                ForEach(userMangaCollection) { userManga in
                                    NavigationLink(value: userManga) {
                                        MangaCard(manga: userManga.toManga())
                                    }
                                    .buttonStyle(.plain)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            userMangaCollectionViewModel.removeFromCollection(from: userManga.id)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    } else {
                        List(userMangaCollection) { userManga in
                            NavigationLink(value: userManga) {
                                MangaRow(manga: userManga.toManga())
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            userMangaCollectionViewModel.removeFromCollection(from: userManga.id)
                                        } label: {
                                            Label("Eliminar", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("My Collection")
            .navigationDestination(for: UserMangaCollection.self) { userManga in
                DetailView(manga: userManga.toManga())
            }
        }
    }
}

#Preview {
    UserMangaCollectionView()
        .environment(UserMangaCollectionViewModel())
}
