//
//  Contact.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Contact: Identifiable, Codable {
    @DocumentID var id: String?
    var userID: String
    var name: String
    var phoneNumber: String
    var imageData: Data?
    
    var profileImage: Image? {
        if let data = imageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    var conversationID: String
}
