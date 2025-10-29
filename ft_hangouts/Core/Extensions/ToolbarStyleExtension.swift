//
//  ToolbarExtension.swift
//  ft_hangouts
//
//  Created by William Deltenre on 14/10/2025.
//

import Foundation
import SwiftUI

extension View {
    func ToolbarStyle(color: Color) -> some View {
        self
            .toolbarBackground(
                Color(color),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .frame(maxWidth: .infinity)
    }
}
