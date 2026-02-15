//
//  FilterSection.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

enum SectionType {
    case genre
    case demographic
    case theme
}

struct FilterSection: View {
    let title: String
    let systemImage: String
    let items: [String]
    let isLoading: Bool
    let sectionType: SectionType
    @Binding var showAll: Bool
    let dataSourceBuilder: (String) -> DataSource
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(title, systemImage: systemImage)
                    .font(.title2)
                    .bold()
                Spacer()
                if !items.isEmpty {
                    Button("See All") {
                        showAll = true
                    }
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
                }
            }
            .padding(.horizontal)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if items.isEmpty {
                Text("No \(title.lowercased()) available")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(items.prefix(4), id: \.self) { item in
                        NavigationLink(value: dataSourceBuilder(item)) {
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
                .padding(.horizontal)
            }
        }
    }
}

//#Preview {
//    FilterSection(title: "Genres", systemImage: "circle.hexagonpath.fill", items: [], isLoading: false, showAll: false, dataSourceBuilder: DataSource.genre(""))
//}
