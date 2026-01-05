//
//  ContentView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = MangaListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.errorMessage {
                    errorView(error: error)
                } else {
                    mangaList
                }
            }
            .navigationTitle("Mangas")
        }
        .task {
            await viewModel.loadMangas()
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Subviews
    
    private var mangaList: some View {
        List {
               ForEach(viewModel.mangas) { manga in
                   NavigationLink {
                       DetailView(manga: manga)
                   } label: {
                       mangaRow(manga: manga)
                   }
                   .task {
                       await viewModel.loadMoreIfNeeded(currentManga: manga)
                   }
               }
               
               if viewModel.isLoadingMore {
                   HStack {
                       Spacer()
                       ProgressView()
                           .padding()
                       Spacer()
                   }
               }
           }
           .listStyle(.plain)
    }
    
    private func mangaRow(manga: Manga) -> some View {
        HStack(spacing: 12) {
            // Portada
            mangaCover(url: manga.mainPicture)
            
            // Información
            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let score = manga.score {
                    Text("⭐️ \(score, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // Info adicional opcional
                if let volumes = manga.volumes {
                    Text("\(volumes) volúmenes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(manga.status)
                    .font(.caption2)
                    .foregroundStyle(.blue)
                ForEach(manga.themes) { theme in
                        Text("• \(theme.theme)")
                    }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func mangaCover(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 2)
            case .failure:
                placeholderImage
            case .empty:
                ProgressView()
                    .frame(width: 80, height: 120)
            @unknown default:
                placeholderImage
            }
        }
    }
    
    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.gray.opacity(0.2))
            .frame(width: 80, height: 120)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.gray)
            }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Cargando mangas...")
                .foregroundStyle(.secondary)
        }
    }
    
    private func errorView(error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.orange)
            
            Text("Error al cargar")
                .font(.headline)
            
            Text(error)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Reintentar") {
                Task {
                    await viewModel.loadMangas()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
