//
//  DetailView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 5/1/26.
//

import SwiftUI

struct DetailView: View {
    let manga: Manga
    @State private var showFullSynopsis = false
    
    var body: some View {
        ScrollView{
            //Portada
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(0.8)
                    .padding()
            } placeholder: {
                Image(systemName: "film")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
            }
            //Capítulos y volúmenes
            HStack{
                Spacer()
                Text("Chapters: \(manga.chapters.map { "\($0)" } ?? "N/A") | Volumes: \(manga.volumes.map { "\($0)" } ?? "N/A")")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 1)
            }
            .padding(.horizontal)
            
            //Título Japonés y puntuación
            HStack{
                Text(manga.titleJapanese ?? "N/A")
                    .font(.subheadline)
                    .padding(.bottom, 0.5)
                Spacer()
                Image(systemName: "star.fill")
                Text(manga.scoreText)
            }
            .padding(.horizontal)
            
            // Título, título inglés y bookmark
            VStack(alignment: .leading){
                HStack {
                    Text(manga.title)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.orange)
                    Spacer()
                    Button {
                        //Agregar a colección
                    } label: {
                        Image(systemName: "bookmark")
                            .foregroundStyle(.orange)
                    }

                }
                Text(manga.titleEnglish ?? "Sin título en Inglés")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            //Géneros y demografía
            HStack (alignment: .top){
                TagSections(title: "Genres", items: manga.genres.map { $0.genre })
                    .padding(.trailing, 50)
                TagSections(title: "Demographics", items: manga.demographics.map { $0.demographic })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            //Autores y temas
            HStack (alignment: .top){
                TagSections(title: "Themes", items: manga.themes.map { $0.theme })
                    .padding(.trailing, 50)
                TagSections(title: "Authors", items: manga.authors.map { $0.fullName })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // Synopsis
            VStack(alignment: .leading) {
                Text(manga.sypnosis ?? "")
                    .lineLimit(showFullSynopsis ? nil : 3)
                    .truncationMode(.tail)
                
                Button(showFullSynopsis ? "Read less" : "Read more") {
                    withAnimation(.easeInOut) {
                        showFullSynopsis.toggle()
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.yellow)
            }
            .padding()
        }
        .background {
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.8))
                    .blur(radius: 20)
                    .ignoresSafeArea()
            } placeholder: {
                Color.black.opacity(0.5).ignoresSafeArea()
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    DetailView(manga: .test)
}
