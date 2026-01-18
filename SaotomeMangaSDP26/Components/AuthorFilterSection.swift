//
//  AuthorFilterSection.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

struct AuthorFilterSection: View {
    let authors: [Author]
    let isLoading: Bool
    @Binding var showAll: Bool
    
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(authors.prefix(5)) { author in
                            NavigationLink(
                                value: DataSource.author(
                                    authorID: author.id.uuidString,
                                    authorName: author.fullName
                                )
                            ) {
                                FilterButton(text: author.fullName)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    AuthorFilterSection(authors:  [Author.test, Author.test, Author.test, Author.test], isLoading: false, showAll: .constant(false))
}
