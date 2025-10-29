//
//  SelectNewChatView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This View displays all contact.
/// Each contact is a button to navigate to a chat. This is also a way to send a message to a contact for the first time.

import SwiftUI

struct SelectNewChatView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    
    @Binding var navigateToConversation: Bool
    @Binding var isShowingNewChat: Bool
    
    var body: some View {
        if chatManager.contacts.isEmpty {
            EmptyContactListView(localizationManager: chatManager.localizationManager)
        } else {
            DisplayContactListView(
                chatManager: chatManager,
                navigateToConversation: $navigateToConversation,
                isShowingNewChat: $isShowingNewChat
            )
        }
    }
}

private struct DisplayContactListView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    
    @Binding var navigateToConversation: Bool
    @Binding var isShowingNewChat: Bool
    
    var body: some View {
        ScrollView {
            ScrollViewReader { reader in
                VStack(spacing: 0) {
                    ForEach(chatManager.contacts) { contact in
                        Button(action: {
                            chatManager.selectedConversationID = contact.conversationID
                            chatManager.selectedContact = contact
                            isShowingNewChat = false
                            navigateToConversation = true
                        }) {
                            DisplayContactView(contact: contact)
                        }
                    }
                    .border(Color.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

private struct DisplayContactView: View {
    var contact: Contact
    
    var body: some View {
        HStack {
            ProfileImageView(contact: contact, width: 40, height: 40)
            
            DisplayContactInfoView(contact: contact)
            
            Spacer()
            
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

private struct DisplayContactInfoView: View {
    var contact: Contact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(contact.name)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(2)
            Text(contact.phoneNumber)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(2)
        }
    }
}
