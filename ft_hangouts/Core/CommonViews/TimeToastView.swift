//
//  TimeToastView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 24/10/2025.
//

/// This view is displayed everytime the app is opened.

import SwiftUI

struct TimeToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.75))
                    .shadow(radius: 5)
            )
            .padding(.bottom, 50)
    }
}
