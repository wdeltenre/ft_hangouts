//
//  ContactListView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 12/10/2025.
//

/// This is the primary, top-level View for the Contact List Feature.
/// Users can either create a new user ou view the details of an existing one.

import SwiftUI

struct ContactListView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    
    @StateObject var viewModel: ContactListViewModel
    
    @State var navigateToEditContact: Bool = false
    
    init(chatManager: FirebaseChatManager) {
        self._chatManager = ObservedObject(wrappedValue: chatManager)
        self._viewModel = StateObject(wrappedValue: ContactListViewModel(chatManager: chatManager))
    }
    
    var body: some View {
        ZStack() {
            ContactListContentView(viewModel: viewModel)
            NavigateToEditContactButtonView(navigateToEditContact: $navigateToEditContact)
        }
        
        .navigationDestination(isPresented: $navigateToEditContact) {
            EditContactView(
                chatManager: chatManager,
                contact: Contact(
                    userID: "",
                    name: "",
                    phoneNumber: "",
                    conversationID: ""
                )
            )
        }
        
        .ToolbarStyle(color: viewModel.colorThemeManager.selectedColor.color)
        .ContactListToolbar(viewModel: viewModel)
    }
}

private struct NavigateToEditContactButtonView: View {
    @Binding var navigateToEditContact: Bool
    
    var body: some View {
        Button(action: {
            self.navigateToEditContact = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.cyan)
                .shadow(radius: 5)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}
