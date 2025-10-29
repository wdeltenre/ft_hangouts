//
//  DetailsView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 17/10/2025.
//

/// This view displays the content of the feature's view.
/// Also creates the 'delete contact' button

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel: ContactDetailsViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            ProfileImageView(contact: viewModel.contact, width: 125, height: 125)
            
            Text(viewModel.contactName)
                .font(.largeTitle)
            
            GoToChatButton(viewModel: viewModel)
            
            PhoneNumberView(viewModel: viewModel)
            
            Spacer()
                
            DeleteContactButton(viewModel: viewModel)
        }
    }
}

private struct GoToChatButton : View {
    @ObservedObject var viewModel: ContactDetailsViewModel
    
    var body: some View {
        Button {
            viewModel.navigateToChat()
        } label: {
            Image(systemName: "message")
                .foregroundColor(Color.cyan)
                .modifier(
                    BorderFontModifier(
                        font: .title,
                        borderColor: Color.cyan,
                        bgColor: Color.cyan.opacity(0.1)
                    )
                )
        }
        Text("MESSAGE".localized(using: viewModel.localizationManager))
            .font(.subheadline)
    }
}

private struct PhoneNumberView : View {
    @ObservedObject var viewModel: ContactDetailsViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "phone")
                .padding(.horizontal, 10)
            Text(viewModel.formattedPhoneNumber)
                .padding(.horizontal, 10)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .modifier(BorderFontModifier(font: .title3, borderColor: .black, bgColor: Color(.systemGray5)))
        .padding(.horizontal, 20)
    }
}

private struct DeleteContactButton : View {
    @ObservedObject var viewModel: ContactDetailsViewModel
    
    var body: some View {
        Button(role: .destructive) {
            viewModel.showingDeleteConfirmation = true
        } label: {
            Text("DELETE_CONTACT".localized(using: viewModel.localizationManager))
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
