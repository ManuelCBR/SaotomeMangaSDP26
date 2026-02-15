//
//  FiltersGridView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 17/1/26.
//

import SwiftUI

struct FiltersGridView: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let items: [String]
    let sectionType: SectionType
    let dataSourceBuilder: (String) -> DataSource
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(value: dataSourceBuilder(item)) {
                            // Usar el componente visual según el tipo
                            switch sectionType {
                            case .genre:
                                GenreGridItem(text: item)
                            case .demographic:
                                DemographicGridItem(text: item)
                            case .theme:
                                ThemeGridItem(text: item)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: DataSource.self) { dataSource in
                FilteredMangaListView(dataSource: dataSource)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
    
#Preview("Filters Grid - Genres") {
    FiltersGridView(
        title: "Genres",
        items: ["Shounen", "Seinen", "Shoujo", "Josei", "Isekai"],
        sectionType: .genre, dataSourceBuilder: { genre in
            DataSource.genre("Josei")
        }
    )
}
