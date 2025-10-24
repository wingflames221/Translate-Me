//
//  TranslationService.swift
//  Translate Me
//
//  Created by shaun amoah on 10/21/25.
//

import SwiftUI

class TranslationService: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func translate(text: String, from sourceLang: String, to targetLang: String) async -> String? {
        let baseURL = "https://api.mymemory.translated.net/get"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=\(encodedText)&langpair=\(sourceLang)|\(targetLang)"
        
        guard let url = URL(string: urlString) else {
            await MainActor.run {
                errorMessage = "Invalid URL"
            }
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
            
            await MainActor.run {
                errorMessage = nil
            }
            
            return response.responseData.translatedText
        } catch {
            await MainActor.run {
                errorMessage = "Translation failed: \(error.localizedDescription)"
            }
            return nil
        }
    }
}
