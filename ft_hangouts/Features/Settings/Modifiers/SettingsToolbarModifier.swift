//
//  SettingsToolbarModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 20/10/2025.
//

import SwiftUI

struct SettingsToolbarModifier: ViewModifier {
    @ObservedObject var viewModel: SettingsViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SETTINGS".localized(using: viewModel.localizationManager))
                        .foregroundColor(.white)
                }
            }
    }
}

extension View {
    func SettingsToolbar(viewModel: SettingsViewModel) -> some View {
        self.modifier(SettingsToolbarModifier(viewModel: viewModel))
    }
}
