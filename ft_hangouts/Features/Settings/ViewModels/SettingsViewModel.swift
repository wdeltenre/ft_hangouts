//
//  SettingsViewModel.swift
//  ft_hangouts
//
//  Created by William Deltenre on 20/10/2025.
//

import Foundation
import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var localizationManager: LocalizationManager
    @Published var colorThemeManager: ColorThemeManager
    
    @Published var showSuccessMessage: Bool = false
    @Published var isLanguageExpanded: Bool = false
    @Published var isColorExpanded: Bool = false
    
    private let chatManager: FirebaseChatManager
    private var cancellables = Set<AnyCancellable>()
    
    init(chatManager: FirebaseChatManager) {
        self.chatManager = chatManager
        
        self.localizationManager = chatManager.localizationManager
        self.colorThemeManager = chatManager.colorThemeManager
        
        self.setupLocalizationBinding()
        self.setupColorThemeBinding()
    }
    
    private func setupLocalizationBinding() {
        chatManager.$localizationManager
            .removeDuplicates { $0 === $1 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newManager in
                self?.localizationManager = newManager
            }
            .store(in: &cancellables)
        
        chatManager.$localizationManager
            .compactMap { $0 }
            .flatMap { $0.$bundle }
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func setupColorThemeBinding() {
        chatManager.$colorThemeManager
            .removeDuplicates { $0 === $1 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newManager in
                self?.colorThemeManager = newManager
            }
            .store(in: &cancellables)
    }
    
    func saveSettings () {
        self.showSuccessMessage = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showSuccessMessage = false
        }
    }
}
