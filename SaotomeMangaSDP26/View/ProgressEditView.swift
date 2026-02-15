//
//  ProgressEditView.swift
//  SaotomeMangaSDP26
//
//  Created by Manuel Bermudo on 9/1/26.
//

import SwiftUI

struct ProgressEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(UserMangaCollectionViewModel.self) var viewModel
    
    let userMangaCollection: UserMangaCollection
    
    @State private var volumesOwned: Int
    @State private var readingVolume: Int
    @State private var hasCompleteCollection: Bool
    
    init(userManga: UserMangaCollection) {
        self.userMangaCollection = userManga
        _volumesOwned = State(initialValue: userManga.volumesOwned)
        _readingVolume = State(initialValue: userManga.readingVolume)
        _hasCompleteCollection = State(initialValue: userManga.hasCompleteCollection)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Volumes you own") {
                    Stepper("\(volumesOwned) volumes", value: $volumesOwned, in: 0...999)
                }
                
                Section("Volume you are reading") {
                    Stepper("Volume \(readingVolume)", value: $readingVolume, in: 0...volumesOwned)
                }
                
                Section {
                    Toggle("Complete collection", isOn: $hasCompleteCollection)
                }
            }
            .navigationTitle("Edit progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.updateProgress(
                            mangaID: userMangaCollection.id,
                            volumesOwned: volumesOwned,
                            readingVolume: readingVolume,
                            hasCompleteCollection: hasCompleteCollection
                        )
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {

    let userManga = UserMangaCollection(from: .test)
    userManga.volumesOwned = 10
    userManga.readingVolume = 5
    
    return ProgressEditView(userManga: userManga)
            .environment(UserMangaCollectionViewModel())
            
}
