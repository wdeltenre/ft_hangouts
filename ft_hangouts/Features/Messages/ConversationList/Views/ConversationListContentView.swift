//
//  ConversationListContentView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view creates a button for each existing conversation.
/// Clicking one a conversation makes the user navigate to the selected conversation.
///
import SwiftUI

struct ConversationListContentView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.activeConversationPreviews.isEmpty {
                EmptyConversationListView(viewModel: viewModel)
            } else {
                DisplayConversationListView(viewModel: viewModel)
            }
        }
    }
}

private struct EmptyConversationListView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            Text("NO_CONVERSATIONS".localized(using: viewModel.localizationManager))
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("START_CHAT".localized(using: viewModel.localizationManager))
                .font(.subheadline)
            
            Spacer()
        }
    }
}

private struct DisplayConversationListView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    
    var body: some View {
        ScrollView {
            ScrollViewReader { reader in
                VStack(spacing: 0) {
                    ForEach(viewModel.activeConversationPreviews) { contact in
                        if let conversation = viewModel.getConversation(for: contact) {
                            Button(action: {
                                viewModel.selectConversation(for: contact)
                                viewModel.navigateToConversation = true
                            }) {
                                ConversationPreviewView(
                                    viewModel: viewModel,
                                    contact: contact,
                                    conversation: conversation
                                )
                            }
                        }
                    }
                    .border(Color.gray)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .background(Color(.systemGray6))
    }
}
