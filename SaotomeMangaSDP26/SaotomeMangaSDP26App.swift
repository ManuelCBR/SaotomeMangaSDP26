//
//  SaotomeMangaSDP26App.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 28/12/25.
//

import SwiftUI
import SwiftData

@main
struct SaotomeMangaSDP26App: App {
    @State private var vmMangaList = MangaListViewModel()
    @State private var vmUserCollection = UserMangaCollectionViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vmMangaList)
                .environment(vmUserCollection)
        }
        .modelContainer(for: UserMangaCollection.self)
    }
}
