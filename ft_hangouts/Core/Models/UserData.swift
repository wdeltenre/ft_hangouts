//
//  UserData.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import FirebaseFirestore

struct UserData: Identifiable, Codable {
    @DocumentID var id: String?
    var phoneNumber: String
    var contactsID: [String]
}
