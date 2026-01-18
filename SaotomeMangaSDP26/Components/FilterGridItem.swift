//
//  FilterGridItem.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

struct FilterGridItem: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .padding()
            .background(.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.yellow)
            .lineLimit(2)
    }
}

#Preview {
    FilterGridItem(text: "Author")
}
