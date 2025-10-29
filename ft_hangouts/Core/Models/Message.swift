//
//  Message.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var conversationID: String
    var senderID: String
    var text: String
    var timestamp: Date
}
