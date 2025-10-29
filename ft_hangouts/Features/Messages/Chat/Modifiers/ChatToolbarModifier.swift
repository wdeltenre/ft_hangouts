//
//  ChatToolbarModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import SwiftUI

struct ChatToolbarModifier: ViewModifier {
    @ObservedObject var viewModel: ChatViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 0) {
                        ProfileImageView(contact: viewModel.contact, width: 30, height: 30)
                            .padding(.trailing, 5)
                        Text(viewModel.contactName)
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

extension View {
    func ChatToolbar(viewModel: ChatViewModel) -> some View {
        self.modifier(ChatToolbarModifier(viewModel: viewModel))
    }
}
