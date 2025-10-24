//
//  ContentView.swift
//  Translate Me
//
//  Created by shaun amoah on 10/21/25.
//

import SwiftUI

struct TranslateView: View {
    @StateObject private var translationService = TranslationService()
    @StateObject private var firebaseManager = FirebaseManager()
    
    @State private var inputText = ""
    @State private var translatedText = ""
    @State private var sourceLang = "en"
    @State private var targetLang = "es"
    @State private var showingSavedTranslations = false
    @State private var showingProfile = false
    @State private var userEmail = "user@example.com"
    
    let languages = [
        "en": "English",
        "es": "Spanish",
        "fr": "French",
        "de": "German",
        "it": "Italian",
        "pt": "Portuguese",
        "ru": "Russian",
        "ja": "Japanese",
        "zh": "Chinese",
        "ar": "Arabic"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // User Profile Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Translate Me")
                            .font(.system(size: 34, weight: .bold))
                        Text(userEmail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Language Selection
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Picker("Source", selection: $sourceLang) {
                            ForEach(languages.keys.sorted(), id: \.self) { key in
                                Text(languages[key] ?? key).tag(key)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Picker("Target", selection: $targetLang) {
                            ForEach(languages.keys.sorted(), id: \.self) { key in
                                Text(languages[key] ?? key).tag(key)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Input Field
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter text to translate", text: $inputText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .font(.system(size: 17))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Translate Button
                Button(action: performTranslation) {
                    HStack {
                        if translationService.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Translate Me")
                                .font(.system(size: 17, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(inputText.isEmpty || translationService.isLoading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Translation Result
                VStack(alignment: .leading, spacing: 8) {
                    Text(translatedText.isEmpty ? "" : translatedText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .frame(minHeight: 100, alignment: .topLeading)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .font(.system(size: 17))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Error Message
                if let error = translationService.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }
                
                Spacer()
                
                // View Saved Translations
                Button(action: { showingSavedTranslations = true }) {
                    Text("View Saved Translations")
                        .font(.system(size: 17))
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 30)
            }
            .background(Color(.systemBackground))
            .sheet(isPresented: $showingSavedTranslations) {
                SavedTranslationsView(firebaseManager: firebaseManager)
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView(email: $userEmail)
            }
        }
        .onAppear {
            loadUserEmail()
        }
    }
    
    private func loadUserEmail() {
        if let savedEmail = UserDefaults.standard.string(forKey: "userEmail") {
            userEmail = savedEmail
        }
    }
    
    private func performTranslation() {
        guard !inputText.isEmpty else { return }
        
        translationService.isLoading = true
        
        Task {
            if let result = await translationService.translate(
                text: inputText,
                from: sourceLang,
                to: targetLang
            ) {
                await MainActor.run {
                    translatedText = result
                    
                    // Save to Firebase
                    let translation = Translation(
                        sourceText: inputText,
                        translatedText: result,
                        sourceLang: sourceLang,
                        targetLang: targetLang,
                        timestamp: Date()
                    )
                    firebaseManager.saveTranslation(translation)
                    
                    translationService.isLoading = false
                }
            } else {
                await MainActor.run {
                    translationService.isLoading = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView()
    }
}
