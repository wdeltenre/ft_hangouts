//
//  ChatViewModel.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var localizationManager: LocalizationManager
    @Published var colorThemeManager: ColorThemeManager
    
    private let chatManager: FirebaseChatManager
    private var cancellables = Set<AnyCancellable>()
    
    init(chatManager: FirebaseChatManager) {
        self.chatManager = chatManager
        
        self.localizationManager = chatManager.localizationManager
        self.colorThemeManager = chatManager.colorThemeManager
        
        self.setupLocalizationBinding()
        self.setupColorThemeBinding()
        
        chatManager.$messages
            .assign(to: &$messages)
    }
    
    var contact: Contact {
        return chatManager.selectedContact!
    }
    
    var currentUserID: String {
        return chatManager.UID
    }
    
    var contactName: String {
        return contact.name
    }
    
    var isConversationSelected: Bool {
        return !chatManager.selectedConversationID.isEmpty
    }
    
    func sendMessage(text: String) {
        chatManager.sendMessage(text: text)
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
