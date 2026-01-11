//
//  UserMangaCollectionViewModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 7/1/26.
//

import Foundation
import SwiftData

@Observable
final class UserMangaCollectionViewModel {
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        modelContext = context
    }
    
    //Añadir a colección
    func addToCollection (from manga: Manga){
        guard let context = modelContext else { return }
        
        let myManga = UserMangaCollection(from: manga)
        
        context.insert(myManga)
        do {
            try context.save()
        } catch {
            print("SwiftData save error:", error)
        }
    }
    
    //Eliminar de colección
    func removeFromCollection (from mangaID: Int){
        guard let context = modelContext else { return }
        
        let fetch = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.id == mangaID }
        )
        if let myManga = try? context.fetch(fetch).first {
            context.delete(myManga)
            try? context.save()
        }
    }
    
    //@Manuel, ver si es necesario.
    func updateProgress(
        mangaID: Int,
        volumesOwned: Int,
        readingVolume: Int,
        hasCompleteCollection: Bool
    ) {
        guard let context = modelContext else { return }
        
        let fetch = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.id == mangaID }
        )
        if let myManga = try? context.fetch(fetch).first {
            myManga.volumesOwned = volumesOwned
            myManga.readingVolume = readingVolume
            myManga.hasCompleteCollection = hasCompleteCollection
            try? context.save()
        }
    }
    
    //Ver si está en la colección
    func isInCollection(_ mangaID: Int) -> Bool {
        guard let context = modelContext else { return false }
        
        let fetch = FetchDescriptor<UserMangaCollection>(predicate: #Predicate { $0.id == mangaID })
        let count = (try? context.fetchCount(fetch)) ?? 0
        return count > 0
    }
    
    //Añadir o no a la colección
    func toggleCollection(_ manga: Manga) {
        if isInCollection(manga.id) {
            removeFromCollection(from: manga.id)
        } else {
            addToCollection(from: manga)
        }
    }
    
    //Obtener si un manga está en la colección
    func getMangaFromCollection(_ mangaID: Int) -> UserMangaCollection? {
        guard let context = modelContext else { return nil }
        
        let fetch = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.id == mangaID }
        )
        return try? context.fetch(fetch).first
    }
}
