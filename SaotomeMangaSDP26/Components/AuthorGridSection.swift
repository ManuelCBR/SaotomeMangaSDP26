//
//  AuthorGridSection.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

struct AuthorGridSection: View {
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
                Button("See All") {
                    showAll = true
                }
                .font(.subheadline)
                .foregroundStyle(.yellow)
            }
            .padding(.horizontal)
            
            // Grid 2x2 con placeholders visuales
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<4, id: \.self) { _ in
                    Button {
                        showAll = true
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.title2)
                            Text("Search authors...")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding()
                        .frame(height: 80)
                        .background(.orange.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.orange)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AuthorGridSection(showAll: .constant(false))
}
