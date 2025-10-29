//
//  String+Localized.swift
//  ft_hangouts
//
//  Created by William Deltenre on 22/10/2025.
//

import SwiftUI

extension String {
    func localized(using manager: LocalizationManager) -> String {
        return manager.bundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    func localized(using manager: LocalizationManager, arguments: CVarArg...) -> String {
            let localizedFormat = manager.bundle.localizedString(forKey: self, value: self, table: nil)
            
            return String(format: localizedFormat, arguments: arguments)
        }
}
