//
//  AuthorGridSection.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

struct AuthorGridSection: View {
    let authors: [Author]
    let isLoading: Bool
    @Binding var showAll: Bool
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Authors", systemImage: "person.fill")
                    .font(.title2)
                    .bold()
                Spacer()
                if !authors.isEmpty {
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
            } else if authors.isEmpty {
                Text("No authors available")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                // Grid 2x2 con los primeros 4 autores
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(authors.prefix(4)) { author in
                        NavigationLink(
                            value: DataSource.author(
                                authorID: author.id.uuidString,
                                authorName: author.fullName
                            )
                        ) {
                            AuthorGridItem(author: author)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview() {
    AuthorGridSection(authors: [.test], isLoading: false, showAll: .constant(false))
}

