//
//  MessageBubbleModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import SwiftUI

struct MessageBubbleModifier: ViewModifier {
    let position: Edge.Set
    let backgroundColor: Color
    let verticalPaddingOutside: CGFloat

    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .foregroundColor(Color.primary)
            .padding(.vertical, 5)
            .padding(.horizontal,10)
            .background(backgroundColor)
            .cornerRadius(20)
            .padding(.top, verticalPaddingOutside)
            .padding(position, 20)
            .padding(position == .leading ? .trailing : .leading, 5)
    }
}
