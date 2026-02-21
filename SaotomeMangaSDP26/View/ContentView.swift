//
//  ContentView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
                Tab("Mangas", systemImage: "safari") {
                    MangaListView()
                }
                
                Tab("My Collection", systemImage: "bookmark") {
                    UserMangaCollectionView()
                }
                
                Tab("Best mangas", systemImage: "star.fill") {
                    BestMangasView()
                }
                Tab("Search", systemImage: "magnifyingglass", role: .search) {
                    SearchView()
                }
            
        }
        .tabBarMinimizeIfAvailable()
        .tabViewStyle(.sidebarAdaptable)
        .preferredColorScheme(.dark)
    }
}

private extension View {
    @ViewBuilder
    func tabBarMinimizeIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }
}

#Preview {
    ContentView()
}
