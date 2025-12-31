//
//  ContentView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var mangas: [Manga]
    var body: some View {
        List(mangas) {manga in
            Text(manga.title)
        }
    }
}

#Preview (traits: .sampleData){
    ContentView()
}
