//
//  AuthorSearchView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

import SwiftUI

struct AuthorSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    var viewModel: SearchFilterViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Search Authors",
                        systemImage: "person.fill.questionmark",
                        description: Text("Start typing to search authors")
                    )
                } else if viewModel.isSearchingAuthors {
                    ProgressView("Searching authors...")
                } else if let error = viewModel.authorSearchError {
                    ContentUnavailableView(
                        "Search Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else if viewModel.searchedAuthors.isEmpty {
                    ContentUnavailableView(
                        "No Authors Found",
                        systemImage: "person.slash",
                        description: Text("No authors found for '\(searchText)'")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.searchedAuthors) { author in
                                NavigationLink(
                                    value: DataSource.author(
                                        authorID: author.id.uuidString,
                                        authorName: author.fullName
                                    )
                                ) {
                                    AuthorGridItem(author: author)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .systemGroupedBackground))
                }
            }
            .navigationTitle("Authors")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: DataSource.self) { dataSource in
                FilteredMangaListView(dataSource: dataSource)
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Author name..."
            )
            .onChange(of: searchText) { _, newValue in
                if !newValue.isEmpty {
                    Task {
                        await viewModel.searchAuthors(query: newValue)
                    }
                }
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

#Preview {
    AuthorSearchView(viewModel: SearchFilterViewModel())
}
