//
//  ConversationPreviewView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view displays a preview for an existing conversation.

import SwiftUI

struct ConversationPreviewView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    var contact: Contact
    var conversation: Conversation
    
    var body: some View {
        HStack(spacing: 5) {
            ProfileImageView(contact: contact, width: 50, height: 50)
                .padding()
            
            MessagePreviewView(viewModel: viewModel, contact: contact, conversation: conversation)
            
            Spacer()
            
            TimeSentView(conversation: conversation)
        }
    }
}

private struct MessagePreviewView: View {
    @ObservedObject var viewModel: ConversationListViewModel
    var contact: Contact
    var conversation: Conversation
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.name)
                .font(.headline)
                .foregroundColor(.primary)
            Text(
                conversation.lastMessageSenderID == viewModel.currentUserID ?
                "YOU".localized(using: viewModel.localizationManager, arguments: conversation.lastMessage ?? "...") :
                    conversation.lastMessage ?? "..."
            )
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
        }
        .padding(.leading, 5)
    }
}

private struct TimeSentView: View {
    var conversation: Conversation
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(previewTimeFormatter(date: conversation.lastMessageTimestamp ?? Date()))
                .foregroundColor(.secondary)
                .padding(.trailing, 10)
        }
    }
}
