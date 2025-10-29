//
//  ConfirmationToast.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view displays a small Toast when saving a contact.

import SwiftUI

struct ConfirmationToast: View {
    let successMessage: String
    
    var body: some View {
        Text(successMessage)
            .font(.subheadline)
            .padding()
            .background(Color.green.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 10)
    }
}
