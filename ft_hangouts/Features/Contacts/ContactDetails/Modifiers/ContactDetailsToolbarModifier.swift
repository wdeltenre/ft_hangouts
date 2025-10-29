//
//  ContactToolbarModifier.swift
//  ft_hangouts
//
//  Created by William Deltenre on 17/10/2025.
//

import SwiftUI

struct ContactToolbarModifier: ViewModifier {
    @Binding var navigateToSaveContact: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.navigateToSaveContact = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .padding(.trailing)
                    }
                }
            }
    }
}

extension View {
    func ContactToolbar(navigateToSaveContact: Binding<Bool>) -> some View {
        self.modifier(ContactToolbarModifier(navigateToSaveContact: navigateToSaveContact))
    }
}
