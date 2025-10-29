//
//  ContactListContentView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view creates a navigation link for each contact.
/// Clicking a contact displays all its details.

import SwiftUI

struct ContactListContentView: View {
    @ObservedObject var viewModel: ContactListViewModel
    
    var body: some View {
        if viewModel.contacts.isEmpty {
            EmptyContactListView(localizationManager: viewModel.localizationManager)
        } else {
            ScrollView {
                ScrollViewReader { reader in
                    VStack(spacing: 0) {
                        ForEach(viewModel.contacts) { contact in
                            NavigationLink(destination: ContactDetailsView(chatManager: viewModel.chatManager, contact: contact)) {
                                ContactPreviewView(contact: contact)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 5)
            .background(Color(.systemGray6))
        }
    }
}
