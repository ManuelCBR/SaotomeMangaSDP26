//
//  MangaRow.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 7/1/26.
//

import SwiftUI
import SwiftData

struct MangaRow: View {
    let manga: Manga
    
    @Query private var userCollection: [UserMangaCollection]
    
    private var isFavorite: Bool {
        userCollection.contains { $0.id == manga.id }
        }
    var body: some View {
        HStack (alignment: .top){
            AsyncImage(url: manga.mainPicture) {image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                Image(systemName: "film")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 120)
                    .padding()
                    .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
            }
            
            VStack (alignment: .leading){
                HStack{
                    Text(manga.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.primary)
                    Spacer()
                    Button {
                        //action
                    } label: {
                        Image(systemName:  isFavorite ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(.orange)
                    }

                    
                }
                .padding(.bottom, 1)
                Text(manga.titleJapanese ?? "N/A")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 2)
                HStack{
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    Text("\(manga.scoreText)")
                        .font(.title3)
                        .bold()
                }
                .padding(.bottom, 1)
                Text("\(manga.background ?? "N/A")")
                    .font(.caption)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
    MangaRow(manga: .test)
}
