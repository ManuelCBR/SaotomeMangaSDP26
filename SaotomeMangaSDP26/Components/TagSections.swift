//
//  TagSections.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 5/1/26.
//

import SwiftUI

struct TagSections: View {
    let title: String
    let items: [String]?
    let symbol: String
    let accentColor: Color
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: symbol)
                        .font(.subheadline)
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.secondary)
                
                ForEach(items ?? ["N/A"], id: \.self) { item in
                    Text(item)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(accentColor.opacity(0.15))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(accentColor.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .foregroundStyle(accentColor)
                }
            }
        }
    }

#Preview {
    TagSections(title: "Authors", items: ["Naoki Urasawa"], symbol: "circle.hexagonpath.fill", accentColor: .blue)
}
