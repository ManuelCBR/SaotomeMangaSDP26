//
//  AuthorGridItem.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 25/1/26.
//

import SwiftUI

struct AuthorGridItem: View {
    let author: Author
    
    private var gradient: LinearGradient {
        LinearGradient(
            colors: [.orange.opacity(0.6), .red.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 35))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(author.fullName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                
                Text(author.role)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(1)
            }
        }
        .padding()
        .frame(height: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                gradient
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .offset(x: 50, y: -30)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    AuthorGridItem(author: .test)
}
