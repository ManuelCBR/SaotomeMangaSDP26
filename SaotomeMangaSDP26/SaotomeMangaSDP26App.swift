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
    @State private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            AuthContainerView()
                .environment(vmMangaList)
                .environment(vmUserCollection)
                .environment(authViewModel)
        }
        .modelContainer(for: UserMangaCollection.self)
    }
}
