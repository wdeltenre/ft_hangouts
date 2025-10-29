//
//  ProfileImageView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view displays the profile picture of a contact.

import SwiftUI

struct ProfileImageView: View {
    var contact: Contact
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Group {
            if let data = contact.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .frame(width: width, height: height)
    }
}
