//
//  ConfirmButton.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view creates a button that sends the modified data to the firebase database.

import SwiftUI

struct ConfirmButton: View {
    @ObservedObject var viewModel: EditContactViewModel
    
    var body: some View {
        Button(action: {
            if !viewModel.contact.name.isEmpty && !viewModel.contact.phoneNumber.isEmpty {
                viewModel.saveContactAction()
            } else {
                viewModel.emptyName = viewModel.contact.name.isEmpty
                viewModel.emptyPhoneNumber = viewModel.contact.phoneNumber.isEmpty
            }
        }) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.cyan)
                .shadow(radius: 5)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}
