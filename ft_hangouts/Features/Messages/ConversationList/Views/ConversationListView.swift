//
//  ConversationListView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 12/10/2025.
//

/// This is the primary, top-level View for the Conversation List Feature.

import Foundation
import SwiftUI

struct ConversationListView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    
    @StateObject private var viewModel: ConversationListViewModel
    
    init(chatManager: FirebaseChatManager) {
        self._chatManager = ObservedObject(wrappedValue: chatManager)
        self._viewModel = StateObject(wrappedValue: ConversationListViewModel(chatManager: chatManager))
    }
    
    var body: some View {
        ZStack {
            ConversationListContentView(viewModel: viewModel)
            
            VStack(spacing: 0) {
                NavigateToContactListButton(navigateToContactList: $viewModel.navigateToContactList)
                
                NewChatButton(isShowingNewChat: $viewModel.isShowingNewChat)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        
        .ToolbarStyle(color: viewModel.colorThemeManager.selectedColor.color)
        .ConversationListToolbar(viewModel: viewModel)
        
        .navigationDestination(isPresented: $viewModel.navigateToContactList) {
            ContactListView(chatManager: chatManager)
        }
        
        .navigationDestination(isPresented: $viewModel.navigateToConversation) {
            ChatView(chatManager: chatManager)
        }
        
        .navigationDestination(isPresented: $viewModel.navigateToSettings) {
            SettingsView(chatManager: chatManager)
        }
        
        .sheet(isPresented: $viewModel.isShowingNewChat) {
            SelectNewChatView(
                chatManager: chatManager,
                navigateToConversation: $viewModel.navigateToConversation,
                isShowingNewChat: $viewModel.isShowingNewChat
            )
        }
    }
}

private struct NavigateToContactListButton : View {
    @Binding var navigateToContactList: Bool
    
    var body: some View {
        Button(action: { navigateToContactList = true }) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.cyan)
                .shadow(radius: 5)
        }
        .padding()
    }
}

private struct NewChatButton : View {
    @Binding var isShowingNewChat: Bool
    
    var body: some View {
        Button(action: { isShowingNewChat = true }) {
            Image(systemName: "message.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.cyan)
                .shadow(radius: 5)
        }
        .padding()
    }
}
