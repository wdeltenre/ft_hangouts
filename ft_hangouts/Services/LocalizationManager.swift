//
//  LocalizationManager.swift
//  ft_hangouts
//
//  Created by William Deltenre on 20/10/2025.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case dutch = "nl"
    case french = "fr"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .dutch: return "Nederlands"
        case .french: return "Français"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇬🇧"
        case .dutch: return "🇳🇱"
        case .french: return "🇫🇷"
        }
    }
}

final class LocalizationManager: ObservableObject {
    private let languageKey = "AppLanguageKey"
    
    @Published var selectedLanguage: AppLanguage
    @Published var bundle: Bundle = Bundle.main
    
    init() {
        let savedCode = UserDefaults.standard.string(forKey: languageKey)
        let savedLanguage = savedCode.flatMap { AppLanguage(rawValue: $0) }
        
        self.selectedLanguage = savedLanguage ?? .english
        
        self.bundle = Self.getBundle(for: self.selectedLanguage)
    }
    
    private static func getBundle(for language: AppLanguage) -> Bundle {
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") else {
            return Bundle.main
        }
        
        return Bundle(path: path) ?? Bundle.main
    }
    
    func setLanguage(_ language: AppLanguage) {
        selectedLanguage = language
        
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)
        
        self.bundle = Self.getBundle(for: language)
        
        print("Language set to: \(language.displayName)")
    }
}
