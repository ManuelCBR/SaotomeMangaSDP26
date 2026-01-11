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
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: symbol)
                Text(title)
                    .font(.headline)
            }
            .padding(.bottom, 2)
            ForEach(items ?? ["N/A"], id: \.self) { item in
                Text(item)
                .padding(.horizontal, 6)
                    .background(Capsule().fill(.yellow.opacity(0.2)))
                    .foregroundStyle(.yellow)
            }
        }
    }
}

#Preview {
    TagSections(title: "Authors", items: ["Naoki Urasawa"], symbol: "circle.hexagonpath.fill")
}
