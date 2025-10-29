//
//  ChatContentView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This view creates a scroll view for all messages of a conversation.

import SwiftUI

struct ChatContentView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ScrollView {
            ScrollViewReader { reader in
                VStack(spacing: 0) {
                    ForEach(viewModel.messages.indices, id: \.self) { index in
                        let message = viewModel.messages[index]
                        
                        let previousMessage = index > 0 ? viewModel.messages[index - 1] : nil
                        let previousMessageTime = previousMessage?.timestamp
                        
                        VStack {
                            if (previousMessage == nil || message.timestamp.timeIntervalSince(previousMessageTime!) > 600) {
                                Text(DateFormatter.longTimeFormatter.string(from: message.timestamp))
                                    .font(.system(size: 10))
                                    .padding(.top, 15)
                                    .padding(.bottom, 5)
                            }
                            
                            MessageBubbleView(
                                currentMessage: message,
                                previousMessage: previousMessage,
                                currentUserID: viewModel.currentUserID
                            )
                        }
                    }
                    
                    .onAppear {
                        reader.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
                    }
                    
                    .onChange(of: viewModel.messages.count) {
                        withAnimation {
                            reader.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
                        }
                    }
                    
                }
            }
        }
        .padding(.bottom, 5)
        .background(Color(.systemGray6))
    }
}
