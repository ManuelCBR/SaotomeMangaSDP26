//
//  UserMangaRow.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 9/1/26.
//

import SwiftUI
import SwiftData

struct UserMangaRow: View {
    let userMangaCollection: UserMangaCollection
    
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectioViewModel
    @Query private var userCollection: [UserMangaCollection]
    
    private var isFavorite: Bool {
        userCollection.contains { $0.id == userMangaCollection.id }
        }
    
    var body: some View {
        HStack (alignment: .top){
            AsyncImage(url: URL(string: userMangaCollection.mainPicture ?? "")) {image in
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
                    Text(userMangaCollection.title)
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
                Text(userMangaCollection.titleJapanese ?? "N/A")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 2)
                HStack{
                    Image(systemName: "star.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    Text(userMangaCollection.scoreText)
                        .bold()
                }
                .padding(.bottom, 1)
                Text("\(userMangaCollection.background ?? "N/A")")
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
    let userManga = UserMangaCollection(from: .test)
    userManga.volumesOwned = 10
    userManga.readingVolume = 5
    
    return UserMangaRow(userMangaCollection: userManga)
            .environment(UserMangaCollectionViewModel())
        
}
