//
//  ContactPreviewView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view displays a small preview for a contact.

import SwiftUI

struct ContactPreviewView: View {
    var contact: Contact
    
    var body: some View {
        HStack {
            ProfileImageView(contact: contact, width: 50, height: 50)
            Text(contact.name)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .border(.black)
    }
}
