//
//  EditDetailsView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view displays the modifiable details of a contact.

import SwiftUI

struct EditDetailsView: View {
    @ObservedObject var viewModel: EditContactViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ChangeProfileImageView(viewModel: viewModel)
            
            EditNameView(viewModel: viewModel)

            EditPhoneNumberView(viewModel: viewModel)
        }
    }
}

private struct ChangeProfileImageView: View {
    @ObservedObject var viewModel: EditContactViewModel
    
    var body: some View {
        Group {
            ProfileImageView(contact: viewModel.contact, width: 150, height: 150)
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                viewModel.showingImagePicker = true
            }) {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.cyan)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(4)
        }
        .padding(.bottom, 20)
    }
}

private struct EditNameView: View {
    @ObservedObject var viewModel: EditContactViewModel
    
    var body: some View {
        Text("NAME".localized(using: viewModel.localizationManager, arguments: ":"))
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 50)
            .padding(.vertical, 2)
        
        if viewModel.emptyName {
            Text("FIELD_REQUIRED".localized(using: viewModel.localizationManager))
                .foregroundColor(.red)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 50)
                .padding(.vertical, 2)
        }
        
        TextField("NAME".localized(using: viewModel.localizationManager, arguments: ""), text: $viewModel.contact.name)
            .modifier(ContactInfoBoxModifier())
    }
}

private struct EditPhoneNumberView: View {
    @ObservedObject var viewModel: EditContactViewModel
    
    var body: some View {
        Text("PHONE_NUMBER".localized(using: viewModel.localizationManager, arguments: ":"))
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 50)
            .padding(.vertical, 2)
        
        if viewModel.emptyPhoneNumber {
            Text("FIELD_REQUIRED".localized(using: viewModel.localizationManager))
                .foregroundColor(.red)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 50)
                .padding(.vertical, 2)
        }
        
        TextField("PHONE_NUMBER".localized(using: viewModel.localizationManager, arguments: ""), text: $viewModel.contact.phoneNumber)
            .modifier(ContactInfoBoxModifier())
            .keyboardType(.phonePad)
            .onChange(of: viewModel.contact.phoneNumber) {
                viewModel.formatPhoneNumber()
            }
            .onAppear() {
                viewModel.formatPhoneNumber()
            }
    }
}
