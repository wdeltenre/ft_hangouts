//
//  DeleteConfirmationModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 17/10/2025.
//

import SwiftUI

struct DeleteConfirmationModifier: ViewModifier {
    @ObservedObject var viewModel: ContactDetailsViewModel
    var contact: Contact
    var deleteAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog(
                "DELETE_CONFIRMATION".localized(using: viewModel.localizationManager),
                isPresented: $viewModel.showingDeleteConfirmation, titleVisibility: .visible
            ) {
                Button(
                    "DELETE_CONTACT_NAME".localized(using: viewModel.localizationManager, arguments: contact.name),
                    role: .destructive
                ) {
                    deleteAction()
                }
            } message: {
                Text("CANNOT_BE_UNDONE".localized(using: viewModel.localizationManager))
            }
    }
}

extension View {
    func deleteConfirmation(viewModel: ContactDetailsViewModel, contact: Contact, action: @escaping () -> Void) -> some View {
        self.modifier(DeleteConfirmationModifier(viewModel: viewModel, contact: contact, deleteAction: action))
    }
}
