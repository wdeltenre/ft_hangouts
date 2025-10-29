//
//  AuthView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 08/10/2025.
//

/// This is the primary, top-level View for the Authentification Feature.

import SwiftUI

struct AuthView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    
    @StateObject var viewModel: AuthViewModel
    
    init(chatManager: FirebaseChatManager) {
        self._chatManager = ObservedObject(wrappedValue: chatManager)
        self._viewModel = StateObject(wrappedValue: AuthViewModel(chatManager: chatManager))
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            AuthContentView(viewModel: viewModel)
            
            LanguageSelectionView(viewModel: viewModel)
        }
        .alert(isPresented: .constant(chatManager.alertMessage != nil)) {
            Alert(
                title: Text("ERROR".localized(using: viewModel.localizationManager)),
                message: Text(chatManager.alertMessage ?? "UNKNOWN_ERROR".localized(using: viewModel.localizationManager)),
                dismissButton: .default(Text("OK".localized(using: viewModel.localizationManager))) {
                    chatManager.alertMessage = nil
                }
            )
        }
    }
}

private struct LanguageSelectionView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        Section {
            Menu {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        viewModel.localizationManager.setLanguage(lang)
                    } label: {
                        HStack {
                            Text(lang.flag)
                                .font(.largeTitle)
                            if viewModel.localizationManager.selectedLanguage == lang {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.localizationManager.selectedLanguage.flag)
                        .font(.title)
                }
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}
