//
//  SavedTranslationView.swift
//  Translate Me
//
//  Created by shaun amoah on 10/21/25.
//

import SwiftUI

struct SavedTranslationsView: View {
    @ObservedObject var firebaseManager: FirebaseManager
    @Environment(\.dismiss) var dismiss
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if firebaseManager.translations.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No saved translations yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Translation count and date range
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(firebaseManager.translations.count) Translations")
                            .font(.headline)
                            .foregroundColor(.gray)
                        if let oldest = firebaseManager.translations.last?.timestamp,
                           let newest = firebaseManager.translations.first?.timestamp {
                            Text("From \(oldest.formatted(date: .abbreviated, time: .omitted)) to \(newest.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(firebaseManager.translations) { translation in
                                TranslationCard(
                                    translation: translation,
                                    onDelete: {
                                        firebaseManager.deleteTranslation(translation)  
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
                
                // Clear All Button
                if !firebaseManager.translations.isEmpty {
                    Button(action: {
                        showingClearAlert = true
                    }) {
                        Text("Clear All Translations")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .alert("Clear All Translations?", isPresented: $showingClearAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Clear All", role: .destructive) {
                            firebaseManager.clearAllTranslations()
                        }
                    } message: {
                        Text("This will permanently delete all \(firebaseManager.translations.count) translations. This action cannot be undone.")
                    }
                }
            }
            .navigationTitle("Translation History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Translate Me")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}
