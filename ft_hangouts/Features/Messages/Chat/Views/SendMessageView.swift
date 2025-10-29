//
//  SendMessageView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

/// This is the view where the users can write and send their messages.

import SwiftUI

struct SendMessageView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    @State private var inputText = ""
    
    var body: some View {
        HStack {
            TextField("WRITE_MESSAGE".localized(using: viewModel.localizationManager), text: $inputText, axis: .vertical)
                .lineLimit(1...5)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 5)
                .padding(.vertical)
            
            Button(action: {
                if !inputText.isEmpty {
                    DispatchQueue.main.async {
                        viewModel.sendMessage(text: inputText)
                        inputText = ""
                    }
                }
            }) {
                Image(systemName: "paperplane.circle.fill")
                    .rotationEffect(.degrees(45))
                    .foregroundColor(Color.primary)
                    .font(.title)
            }
            .padding(.trailing, 5)
        }
        .background(Color(.systemGray))
    }
}
