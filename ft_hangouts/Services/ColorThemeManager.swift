//
//  ColorThemeManager.swift
//  ft_hangouts
//
//  Created by William Deltenre on 20/10/2025.
//

import Foundation
import SwiftUI

enum AppThemeColor: String, CaseIterable, Identifiable {
    case gray = "gray"
    case black = "black"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .gray: return "gray"
        case .black: return "black"
        }
    }
    
    var color: Color {
        switch self {
        case .gray: return Color(.systemGray)
        case .black: return Color(.black)
        }
    }
    
    var iconName: String {
            return "circle.fill"
        }
}

final class ColorThemeManager: ObservableObject {
    private let colorKey = "AppColorKey"
    
    @Published var selectedColor: AppThemeColor
    
    init() {
        if let savedCode = UserDefaults.standard.string(forKey: colorKey),
           let savedColor = AppThemeColor(rawValue: savedCode) {
            self.selectedColor = savedColor
        } else {
            self.selectedColor = .gray
        }
    }
    
    func setColor(_ color: AppThemeColor) {
        selectedColor = color
        
        UserDefaults.standard.set(color.rawValue, forKey: colorKey)
        
        print("Color set to: \(color.displayName)")
    }
}
