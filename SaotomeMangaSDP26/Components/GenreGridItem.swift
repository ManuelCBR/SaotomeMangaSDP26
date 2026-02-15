//
//  GenreGridItem.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 25/1/26.
//

import SwiftUI

struct GenreGridItem: View {
    let text: String
    
    private var gradient: LinearGradient {
        let gradients: [LinearGradient] = [
            LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
        ]
        
        // Hash del texto para consistencia"
        let index = abs(text.hashValue) % gradients.count
        return gradients[index]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(height: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(gradient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    GenreGridItem(text: "Action")
}
