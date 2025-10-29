//
//  BorderFontModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 17/10/2025.
//

import SwiftUI

struct BorderFontModifier: ViewModifier {
    let font: Font
    let borderColor: Color
    let bgColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .font(font)
            .padding(5)
            .background(bgColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
            .padding(.top, 10)
    }
}
