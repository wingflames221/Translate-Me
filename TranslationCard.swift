//
//  TranslationCard.swift
//  Translate Me
//
//  Created by shaun amoah on 10/21/25.
//

import SwiftUI

struct TranslationCard: View {
    let translation: Translation
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with timestamp and delete button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(translation.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(formatRelativeTime(translation.timestamp))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                }
            }
            
            Divider()
            
            // Source text
            HStack {
                Text(translation.sourceText)
                    .font(.system(size: 17, weight: .medium))
                Spacer()
                Text(translation.sourceLang.uppercased())
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Divider()
            
            // Translated text
            HStack {
                Text(translation.translatedText)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                Spacer()
                Text(translation.targetLang.uppercased())
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .alert("Delete Translation?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("This translation will be permanently deleted.")
        }
    }
    
    private func formatRelativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
