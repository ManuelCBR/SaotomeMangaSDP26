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
    let dataSourceBuilder: (String) -> DataSource
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(value: dataSourceBuilder(item)) {
                            Text(item)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DataSource.self) { dataSource in
                FilteredMangaListView(dataSource: dataSource)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - AuthorsGridView (para autores)

struct AuthorsGridView: View {
    @Environment(\.dismiss) var dismiss
    
    let authors: [Author]
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(authors) { author in
                        NavigationLink(
                            value: DataSource.author(
                                authorID: author.id.uuidString,
                                authorName: author.fullName
                            )
                        ) {
                            VStack(alignment: .leading) {
                                Text(author.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(author.role)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.yellow)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("All Authors")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DataSource.self) { dataSource in
                FilteredMangaListView(dataSource: dataSource)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
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
        dataSourceBuilder: { genre in
            DataSource.genre("Josei")
        }
    )
}
