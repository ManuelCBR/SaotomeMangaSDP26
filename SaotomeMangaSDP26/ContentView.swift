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
                            ProgressView("Cargando mangas...")
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundStyle(.red)
                        } else {
                            List(viewModel.mangas) { manga in
                                HStack{
                                    VStack(alignment: .leading) {
                                        Text(manga.title)
                                            .font(.headline)
                                        
                                        if let score = manga.score {
                                            Text("⭐️ \(score)")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    AsyncImage(url: manga.mainPicture) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    } placeholder: {
                                        Image(systemName: "film")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Mangas")
                }
                .task {
                    await viewModel.loadMangas()
                }
    }
}

#Preview {
    ContentView()
}
