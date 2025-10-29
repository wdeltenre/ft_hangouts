//
//  ConversationListToolbar.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import SwiftUI

struct ConversationListToolbarModifier: ViewModifier {
    @ObservedObject var viewModel: ConversationListViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("MESSAGES".localized(using: viewModel.localizationManager))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("SETTINGS".localized(using: viewModel.localizationManager)) {
                            viewModel.navigateToSettings = true
                        }
                        Button("LOG_OUT".localized(using: viewModel.localizationManager)) {
                            DispatchQueue.main.async {
                                viewModel.logOut()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

extension View {
    func ConversationListToolbar(viewModel: ConversationListViewModel) -> some View {
        self.modifier(ConversationListToolbarModifier(viewModel: viewModel))
    }
}
