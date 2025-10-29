//
//  ConversationListViewModel.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import Combine

final class ConversationListViewModel: ObservableObject {
    @Published private var allConversations: [Conversation] = []
    @Published private var allContacts: [Contact] = []
    
    @Published var localizationManager: LocalizationManager
    @Published var colorThemeManager: ColorThemeManager
    
    @Published var navigateToContactList: Bool = false
    @Published var navigateToConversation = false
    @Published var navigateToSettings: Bool = false
    @Published var isShowingNewChat: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let chatManager: FirebaseChatManager

    init(chatManager: FirebaseChatManager) {
        self.chatManager = chatManager
        
        self.localizationManager = chatManager.localizationManager
        self.colorThemeManager = chatManager.colorThemeManager
        
        self.setupLocalizationBinding()
        self.setupColorThemeBinding()
        self.setupBindings()
    }

    var activeConversationPreviews: [Contact] {
        return allContacts
            .filter { contact in
                let convID = contact.conversationID
                guard !convID.isEmpty else { return false }
                return self.allConversations.contains(where: { $0.id == convID })
            }
            .sorted { contactA, contactB in
                let timeA = self.getConversation(for: contactA)?.lastMessageTimestamp ?? Date.distantPast
                let timeB = self.getConversation(for: contactB)?.lastMessageTimestamp ?? Date.distantPast
                return timeA > timeB
            }
    }
    
    var currentUserID: String {
        return chatManager.UID
    }

    func getConversation(for contact: Contact) -> Conversation? {
        let convID = contact.conversationID
        guard !convID.isEmpty else { return nil }
        return allConversations.first { $0.id == convID }
    }
    
    func selectConversation(for contact: Contact) {
        self.chatManager.selectedConversationID = contact.conversationID
        self.chatManager.selectedContact = contact
    }
    
    func logOut() {
        chatManager.logOut()
    }
    
    private func setupBindings() {
        chatManager.$contacts
            .sink { [weak self] fetchedContacts in
                self?.allContacts = fetchedContacts
            }
            .store(in: &cancellables)

        chatManager.$conversations
            .sink { [weak self] fetchedConversations in
                self?.allConversations = fetchedConversations
            }
            .store(in: &cancellables)
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
