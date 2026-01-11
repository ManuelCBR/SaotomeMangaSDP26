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
    @Query private var userMangaCollection: [UserMangaCollection]
    
    var body: some View {
        @Bindable var userMangaCollectionViewModel = userMangaCollectionViewModel
        
        NavigationStack {
            Group {  // ← Envuelve el if/else en Group
                if userMangaCollection.isEmpty {
                    ContentUnavailableView(
                        "Empty Collection",
                        systemImage: "bookmark.fill",
                        description: Text("Aún no has guardado ningún manga en tu colección")
                    )
                } else {
                    List(userMangaCollection) { userManga in
                        NavigationLink(value: userManga) {
                            UserMangaRow(userMangaCollection: userManga)
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
