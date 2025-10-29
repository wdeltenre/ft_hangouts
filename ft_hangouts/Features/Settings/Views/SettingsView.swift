//
//  SettingsView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 20/10/2025.
//

/// This is the primary, top-level View for the Settings Feature.

import SwiftUI

struct SettingsView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    
    @StateObject var viewModel: SettingsViewModel
    
    init(chatManager: FirebaseChatManager) {
        self._chatManager = ObservedObject(wrappedValue: chatManager)
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(chatManager: chatManager))
    }
    
    var body: some View {
        SettingsFormView(viewModel: viewModel)
            .ToolbarStyle(color: viewModel.colorThemeManager.selectedColor.color)
            .SettingsToolbar(viewModel: viewModel)
            .background(Color(.systemGray6))
    }
}
