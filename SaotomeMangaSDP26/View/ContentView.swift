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
                TabSection{
                    Tab("Mangas", systemImage: "safari") {
                        MangaListView()
                    }
                    
                    Tab("My Collection", systemImage: "bookmark") {
                        UserMangaCollectionView()
                    }
                }
                
                TabSection{
                    Tab("Search", systemImage: "magnifyingglass", role: .search) {
                        SearchView()
                    }
                }
            }
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
