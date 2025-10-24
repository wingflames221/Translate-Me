//
//  Translation.swift
//  Translate Me
//
//  Created by shaun amoah on 10/21/25.
//

import Foundation

struct Translation: Identifiable, Codable {
    var id = UUID()
    var sourceText: String
    var translatedText: String
    var sourceLang: String
    var targetLang: String
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id, sourceText, translatedText, sourceLang, targetLang, timestamp
    }
}

struct MyMemoryResponse: Codable {
    let responseData: ResponseData
    let responseStatus: Int
    
    struct ResponseData: Codable {
        let translatedText: String
    }
}
