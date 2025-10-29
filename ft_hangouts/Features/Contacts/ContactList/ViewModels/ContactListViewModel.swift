//
//  ContactListViewModel.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import Combine

final class ContactListViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var localizationManager: LocalizationManager
    @Published var colorThemeManager: ColorThemeManager
    
    let chatManager: FirebaseChatManager
    private var cancellables = Set<AnyCancellable>()
    
    init(chatManager: FirebaseChatManager) {
        self.chatManager = chatManager
        
        self.localizationManager = chatManager.localizationManager
        self.colorThemeManager = chatManager.colorThemeManager
        
        self.setupLocalizationBinding()
        self.setupColorThemeBinding()
        
        chatManager.$contacts
            .map { contacts in
                contacts.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            }
            .assign(to: &$contacts)
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
}
