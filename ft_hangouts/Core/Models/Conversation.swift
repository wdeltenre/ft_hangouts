//
//  Conversation.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import FirebaseFirestore

struct Conversation: Codable, Identifiable {
    @DocumentID var id: String?
    var messagesID: [String] // This is a reference to messages from this conversations
    var usersID: [String] // This is a reference to users in the conversations
    var lastMessage: String?
    var lastMessageSenderID: String?
    var lastMessageTimestamp: Date?
}
