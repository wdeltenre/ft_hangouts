//
//  EmptyContactListView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view displays a message when no contacts have been saved by the user.
/// It is used by two features: Contacts/ContactList/ & Message/ConversationList/

import SwiftUI

struct EmptyContactListView: View {
    @ObservedObject var localizationManager: LocalizationManager
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "person")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            Text("NO_CONTACTS".localized(using: localizationManager))
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("ADD_CONTACT".localized(using: localizationManager))
                .font(.subheadline)
            
            Spacer()
        }
    }
}
