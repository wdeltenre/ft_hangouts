//
//  ContactListToolbarModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import SwiftUI

struct ContactListToolbarModifier: ViewModifier {
    @ObservedObject var viewModel: ContactListViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CONTACTS".localized(using: viewModel.localizationManager))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                }
            }
    }
}

extension View {
    func ContactListToolbar(viewModel: ContactListViewModel) -> some View {
        self.modifier(ContactListToolbarModifier(viewModel: viewModel))
    }
}
