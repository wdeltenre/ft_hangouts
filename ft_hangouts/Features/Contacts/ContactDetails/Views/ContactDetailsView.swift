//
//  ContactDetailView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 10/10/2025.
//

/// This is the primary, top-level View for the Contact Details Feature.
/// A button to edit the contact is places in the top toolbar.

import SwiftUI

struct ContactDetailsView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    @State var contact: Contact
    
    @StateObject private var viewModel: ContactDetailsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(chatManager: FirebaseChatManager, contact: Contact) {
        self._chatManager = ObservedObject(wrappedValue: chatManager)
        self._contact = State(wrappedValue: contact)

        self._viewModel = StateObject(wrappedValue: ContactDetailsViewModel(chatManager: chatManager, contact: contact))
    }

    var body: some View {
        DetailsView(
            viewModel: viewModel
        )
        .background(Color(.systemGray6))
        
        .onAppear {
            viewModel.onDismiss = { dismiss() }
        }
        
        .deleteConfirmation(viewModel: viewModel, contact: contact) {
            viewModel.deleteContact()
        }
        
        .ContactToolbar(navigateToSaveContact: $viewModel.navigateToSaveContact)
        .ToolbarStyle(color: viewModel.colorThemeManager.selectedColor.color)
        
        .navigationDestination(isPresented: $viewModel.navigateToSaveContact) {
            EditContactView(chatManager: chatManager, contact: contact)
        }
        .navigationDestination(isPresented: $viewModel.navigateToConversation) {
            ChatView(chatManager: chatManager)
        }
    }
}
