//
//  UserMangaCollectionViewModel.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 7/1/26.
//

import Foundation
import SwiftData

//@manuel BORRAR PRINTS

@Observable
@MainActor
final class UserMangaCollectionViewModel {
    // MARK: - Network
    private let repository = NetworkRepository()
    
    // MARK: - Estados
    var isLoading = false
    var isSyncing = false
    var errorMessage: String?
    var lastSyncDate: Date?
    
    // MARK: - Sincronización inicial
    
    /// Sincroniza la colección local con la API
    func syncWithCloud(context: ModelContext) async {
        guard !isSyncing else { return }
        
        isSyncing = true
        errorMessage = nil
        
        do {
            let cloudItems = try await repository.getUserCollection()
            
            #if DEBUG
            print("☁️ Sincronizando \(cloudItems.count) items de la nube...")
            #endif
            
            for cloudItem in cloudItems {
                let userManga = cloudItem.toUserMangaCollection()
                let mangaId = userManga.id
                
                let fetch = FetchDescriptor<UserMangaCollection>(
                    predicate: #Predicate { $0.id == mangaId }
                )
                
                if let existing = try? context.fetch(fetch).first {
                    existing.volumesOwned = userManga.volumesOwned
                    existing.readingVolume = userManga.readingVolume
                    existing.hasCompleteCollection = userManga.hasCompleteCollection
                } else {
                    context.insert(userManga)
                }
            }
            
            try context.save()
            lastSyncDate = Date()
            
            #if DEBUG
            print("✅ Sincronización completada")
            #endif
            
        } catch {
            #if DEBUG
            print("❌ Error en sincronización: \(error)")
            #endif
            errorMessage = "Sync failed: \(error.localizedDescription)"
        }
        
        isSyncing = false
    }
    
    // MARK: - Añadir a colección
    
    func addToCollection(from manga: Manga, context: ModelContext) {
        let myManga = UserMangaCollection(from: manga)
        context.insert(myManga)
        
        do {
            try context.save()
            #if DEBUG
            print("✅ Manga añadido a SwiftData")
            #endif
            
            Task {
                await syncAddToCloud(myManga)
            }
        } catch {
            #if DEBUG
            print("❌ SwiftData save error:", error)
            #endif
        }
    }
    
    private func syncAddToCloud(_ manga: UserMangaCollection) async {
        do {
            let request = manga.toCreateRequest()
            try await repository.addToCollection(request)
            #if DEBUG
            print("☁️ Manga sincronizado con la nube")
            #endif
        } catch {
            #if DEBUG
            print("⚠️ Error al sincronizar con nube:", error)
            #endif
        }
    }
    
    // MARK: - Eliminar de colección
    
    func removeFromCollection(from mangaID: Int, context: ModelContext) {
        let fetch = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.id == mangaID }
        )
        
        if let myManga = try? context.fetch(fetch).first {
            context.delete(myManga)
            try? context.save()
            #if DEBUG
            print("✅ Manga eliminado de SwiftData")
            #endif
            
            Task {
                await syncDeleteFromCloud(mangaID)
            }
        }
    }
    
    private func syncDeleteFromCloud(_ mangaID: Int) async {
        do {
            try await repository.deleteFromCollection(mangaID)
            #if DEBUG
            print("☁️ Manga eliminado de la nube")
            #endif
        } catch {
            #if DEBUG
            print("⚠️ Error al eliminar de nube:", error)
            #endif
        }
    }
    
    // MARK: - Actualizar progreso
    
    func updateProgress(
        mangaID: Int,
        volumesOwned: Int,
        readingVolume: Int,
        hasCompleteCollection: Bool,
        context: ModelContext
    ) {
        let fetch = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.id == mangaID }
        )
        
        if let myManga = try? context.fetch(fetch).first {
            myManga.volumesOwned = volumesOwned
            myManga.readingVolume = readingVolume
            myManga.hasCompleteCollection = hasCompleteCollection
            try? context.save()
            #if DEBUG
            print("✅ Progreso actualizado en SwiftData")
            #endif
            
            Task {
                await syncUpdateToCloud(myManga)
            }
        }
    }
    
    private func syncUpdateToCloud(_ manga: UserMangaCollection) async {
        do {
            let request = manga.toCreateRequest()
            try await repository.addToCollection(request)
            #if DEBUG
            print("☁️ Progreso sincronizado con la nube")
            #endif
        } catch {
            #if DEBUG
            print("⚠️ Error al sincronizar progreso:", error)
            #endif
        }
    }
    
    // MARK: - Métodos de consulta
    
    func isInCollection(_ mangaID: Int, context: ModelContext) -> Bool {
        let fetch = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.id == mangaID }
        )
        let count = (try? context.fetchCount(fetch)) ?? 0
        return count > 0
    }
    
    func toggleCollection(_ manga: Manga, context: ModelContext) {
        if isInCollection(manga.id, context: context) {
            removeFromCollection(from: manga.id, context: context)
        } else {
            addToCollection(from: manga, context: context)
        }
    }
    
    func getMangaFromCollection(_ mangaID: Int, context: ModelContext) -> UserMangaCollection? {
        let fetch = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.id == mangaID }
        )
        return try? context.fetch(fetch).first
    }
}
