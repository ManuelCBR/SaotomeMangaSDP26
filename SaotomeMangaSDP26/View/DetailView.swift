//
//  DetailView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 5/1/26.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    let manga: Manga
    
    @State private var showFullSynopsis = false
    @State private var showEditProgress = false
    
    @Environment(UserMangaCollectionViewModel.self) var userMangaCollectionViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Query private var userCollection: [UserMangaCollection]

    private var isInCollection: Bool {
        userCollection.contains(where: { $0.id == manga.id })
    }
    
    var body: some View {
        @Bindable var userMangaCollectionViewModel = userMangaCollectionViewModel
        ScrollView{
            //Portada
            AsyncImage(url: manga.mainPicture) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: horizontalSizeClass == .regular ? 400 : .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(0.8)
                    .padding()
            } placeholder: {
                Image(systemName: "film")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: horizontalSizeClass == .regular ? 400 : .infinity)
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
            //Fechas
            HStack{
                Spacer()
                Text("From \(manga.startDateFormatted ?? "") to \(manga.endDateFormatted ?? "")")
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
                        userMangaCollectionViewModel.toggleCollection(manga)
                    } label: {
                        Image(systemName: isInCollection ? "bookmark.fill" : "bookmark")
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
                TagSections(
                    title: "Genres",
                    items: manga.genres.map { $0.genre },
                    symbol: "circle.hexagonpath.fill"
                )
                    .padding(.trailing, 50)
                TagSections(
                    title: "Demographics",
                    items: manga.demographics.map { $0.demographic },
                    symbol: "globe.europe.africa.fill"
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            // Autores y temas
            HStack (alignment: .top){
                TagSections(
                    title: "Themes",
                    items: manga.themes.isEmpty ? ["N/A"] : manga.themes.map { $0.theme },
                    symbol: "text.bubble"
                )
                    .padding(.trailing, 50)
                TagSections(
                    title: "Authors",
                    items: manga.authors.map { $0.fullName },
                    symbol: "person.fill"
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // Synopsis
            VStack(alignment: .leading) {
                Text("Synopsis")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical,1)
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
            
            //Datos de colección si procede
            if let userManga = userMangaCollectionViewModel.getMangaFromCollection(manga.id) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mi Progreso")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 1)
                    
                    // Progreso visual
                    HStack(spacing: 20) {
                        // Tomos que tienes
                        VStack {
                            Label("\(userManga.volumesOwned)", systemImage: "books.vertical.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                            Text("Tomos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        // Tomo leyendo
                        VStack {
                            Label("\(userManga.readingVolume)", systemImage: "book.fill")
                                .font(.title2)
                                .foregroundStyle(.green)
                            Text("Leyendo")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        // Colección completa
                        VStack {
                            Image(systemName: userManga.hasCompleteCollection ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundStyle(userManga.hasCompleteCollection ? .green : .gray)
                            Text("Completa")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    
                    // Botón para editar progreso
                    Button {
                        showEditProgress = true
                    } label: {
                        Label("Editar Progreso", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.yellow)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showEditProgress) {
            if let userManga = userMangaCollectionViewModel.getMangaFromCollection(manga.id) {
                ProgressEditView(userManga: userManga)
            }
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
        .environment(UserMangaCollectionViewModel())
}
