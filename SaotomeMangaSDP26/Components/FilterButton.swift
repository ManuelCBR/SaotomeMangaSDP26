//
//  FilterButton.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 18/1/26.
//

import SwiftUI

struct FilterButton: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
            .foregroundStyle(.yellow)
    }
}

#Preview {
    FilterButton(text: "Marcial Arts")
}
