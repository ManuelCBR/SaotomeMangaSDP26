//
//  MangaCard.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 15/2/26.
//

import SwiftUI
import SwiftData

struct MangaCard: View {
    let manga: Manga
    
    @Query private var userCollection: [UserMangaCollection]
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectionViewModel
    
    private var isInCollection: Bool {
        userCollection.contains { $0.id == manga.id }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Portada
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 240)
                    
                    Image(systemName: "film")
                        .font(.system(size: 40))
                        .foregroundStyle(.gray)
                }
            }
            .overlay(alignment: .topTrailing) {
                // Bookmark button
                Button {
                    userMangaCollectionViewModel.toggleCollection(manga)
                } label: {
                    Image(systemName: isInCollection ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(isInCollection ? .orange :.white)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(8)
            }
            // Título
            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                
                // Puntuación
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text(manga.scoreText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MangaCard(manga: .test)
        .environment(UserMangaCollectionViewModel())
}
