//
//  ThemeGridItem.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 26/1/26.
//

import SwiftUI

struct ThemeGridItem: View {
    let text: String
    
    private var accentColor: Color {
        let colors: [Color] = [.yellow, .orange, .red, .pink, .purple, .blue, .green]
        let index = abs(text.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: "tag.fill")
                .font(.title2)
                .foregroundStyle(accentColor)
            
            Spacer()
            
            Text(text)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(height: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(accentColor.opacity(0.5), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ThemeGridItem(text: "Action")
}
