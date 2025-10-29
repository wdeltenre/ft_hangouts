//
//  EditContactView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 10/10/2025.
//

/// This is the primary, top-level View for the Edit ContactFeature.

import SwiftUI

struct EditContactView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    @State var contact: Contact
    
    @StateObject private var viewModel: EditContactViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(chatManager: FirebaseChatManager, contact: Contact) {
        self._chatManager = ObservedObject(wrappedValue: chatManager)
        self._contact = State(wrappedValue: contact)
        self._viewModel = StateObject(wrappedValue: EditContactViewModel(chatManager: chatManager, contact: contact))
    }
    
    var body: some View {
        ZStack {
            EditDetailsView(viewModel: viewModel)
            
            ConfirmButton(viewModel: viewModel)
        }
        .onAppear {
            viewModel.onDismiss = { dismiss() }
        }
        
        .overlay(alignment: .top) {
            if viewModel.showSuccessMessage {
                ConfirmationToast(successMessage: "CONTACT_SAVED".localized(using: viewModel.localizationManager))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ProfileImagePicker(contact: $viewModel.contact)
        }
        
        .animation(.spring(), value: viewModel.showSuccessMessage)
        .background(Color(.systemGray6))
        
        .alert(isPresented: .constant(viewModel.showAlert != false)) {
            Alert(
                title: Text("ERROR".localized(using: viewModel.localizationManager)),
                message: Text("PHONE_NOT_REGISTERED".localized(using: viewModel.localizationManager)),
                dismissButton: .default(Text("OK".localized(using: viewModel.localizationManager))) {
                    viewModel.showAlert = false
                }
            )
        }
    }
}
