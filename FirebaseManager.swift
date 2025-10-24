//
//  Untitled.swift
//  Translate Me
//
//  Created by shaun amoah on 10/21/25.
//

import Foundation

class FirebaseManager: ObservableObject {
    @Published var translations: [Translation] = []
    private let userDefaults = UserDefaults.standard
    private let translationsKey = "savedTranslations"
    
    init() {
        loadTranslations()
    }
    
    func saveTranslation(_ translation: Translation) {
        translations.insert(translation, at: 0)
        saveToStorage()
    }
    
    func deleteTranslation(_ translation: Translation) {
        translations.removeAll { $0.id == translation.id }
        saveToStorage()
    }
    
    func clearAllTranslations() {
        translations.removeAll()
        saveToStorage()
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(translations) {
            userDefaults.set(encoded, forKey: translationsKey)
        }
    }
    
    private func loadTranslations() {
        if let data = userDefaults.data(forKey: translationsKey),
           let decoded = try? JSONDecoder().decode([Translation].self, from: data) {
            translations = decoded
        }
    }
}
