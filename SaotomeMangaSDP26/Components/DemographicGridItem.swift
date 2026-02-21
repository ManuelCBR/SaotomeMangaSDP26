//
//  DemographicGridItem.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 25/1/26.
//

import SwiftUI

struct DemographicGridItem: View {
    let text: String
    
    private var backgroundColor: Color {
        let colors: [Color] = [.teal, .indigo, .purple, .pink, .cyan]
        let index = abs(text.hashValue) % colors.count
        return colors[index]
    }
    
    private var icon: String {
        switch text.lowercased() {
        case let str where str.contains("shounen"):
            return "figure.run"
        case let str where str.contains("shoujo"):
            return "sparkles"
        case let str where str.contains("seinen"):
            return "person.fill"
        case let str where str.contains("josei"):
            return "leaf.fill"
        case let str where str.contains("kids"):
            return "star.fill"
        default:
            return "person.2.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundStyle(.white.opacity(0.3))
            }
            
            Spacer()
            
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(2)
        }
        .padding()
        .frame(height: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                backgroundColor
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .offset(x: 40, y: -20)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    DemographicGridItem(text: "Demographic")
}
