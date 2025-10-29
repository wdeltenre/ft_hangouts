//
//  ContactInfoBoxModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import SwiftUI

struct ContactInfoBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 50)
            .padding(.bottom, 10)
            .cornerRadius(20)
    }
}


