//
//  PreviewContainer.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 30/12/25.
//

import SwiftUI
import SwiftData

struct PreviewContainer: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Manga.self, configurations: config)
        
        Author.sampleAuthors.forEach { author in
            container.mainContext.insert(author)
        }
        Theme.sampleThemes.forEach { theme in
            container.mainContext.insert(theme)
        }
        Demographics.sampleDemographics.forEach { demographics in
            container.mainContext.insert(demographics)
        }
        Genres.sampleGenres.forEach { genre in
            container.mainContext.insert(genre)
        }
        Manga.sampleManga.forEach { manga in
            container.mainContext.insert(manga)
        }
        try container.mainContext.save()
        
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
    
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(PreviewContainer())
}
