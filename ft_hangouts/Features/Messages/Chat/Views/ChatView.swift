//
//  ChatView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 11/10/2025.
//

/// This is the primary, top-level View for the Chat Feature.

import SwiftUI
import Foundation

struct ChatView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    @StateObject private var viewModel: ChatViewModel
    
    init(chatManager: FirebaseChatManager) {
        self._chatManager = ObservedObject(wrappedValue: chatManager)
        self._viewModel = StateObject(wrappedValue: ChatViewModel(chatManager: chatManager))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if chatManager.selectedConversationID.isEmpty {
                Color(.systemGray6)
            } else {
                ChatContentView(viewModel: viewModel)
            }
            SendMessageView(viewModel: viewModel)
        }
        .ToolbarStyle(color: viewModel.colorThemeManager.selectedColor.color)
        .ChatToolbar(viewModel: viewModel)
    }
}
