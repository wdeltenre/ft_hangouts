//
//  MessageBubbleView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view displays a message.

import SwiftUI

struct MessageBubbleView: View {
    let currentMessage: Message
    let previousMessage: Message?
    let currentUserID: String
    
    var isFromCurrentUser: Bool {
        return currentMessage.senderID == currentUserID
    }
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            Text(currentMessage.text)
                .modifier(
                    MessageBubbleModifier(
                        position: isFromCurrentUser ? .leading : .trailing,
                        backgroundColor: isFromCurrentUser ? Color(.systemCyan) : Color(.systemGray3),
                        verticalPaddingOutside: isFromCurrentUser ? 1 : 10
                    )
                )
            
            if !isFromCurrentUser {
                Spacer()
            }
        }
    }
}
