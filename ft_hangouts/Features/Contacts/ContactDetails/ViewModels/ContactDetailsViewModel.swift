//
//  ContactDetailsViewModel.swift
//  ft_hangouts
//
//  Created by William Deltenre on 17/10/2025.
//

import Foundation
import Combine

final class ContactDetailsViewModel: ObservableObject {
    @Published var contact: Contact
    @Published var localizationManager: LocalizationManager
    @Published var colorThemeManager: ColorThemeManager
    
    @Published var showingDeleteConfirmation: Bool = false
    @Published var navigateToConversation: Bool = false
    @Published var navigateToSaveContact: Bool = false
    
    private let chatManager: FirebaseChatManager
    private var cancellables = Set<AnyCancellable>()
    
    private let initialContactID: String
    
    var onDismiss: (() -> Void)?
    
    init(chatManager: FirebaseChatManager, contact: Contact) {
        self.chatManager = chatManager
        
        self.contact = contact
        self.localizationManager = chatManager.localizationManager
        self.colorThemeManager = chatManager.colorThemeManager
        
        self.initialContactID = contact.id!
        self.setupContactObserver()
        
        self.setupLocalizationBinding()
        self.setupColorThemeBinding()
    }
    
    func navigateToChat() {
        chatManager.selectedConversationID = contact.conversationID
        chatManager.selectedContact = contact
        navigateToConversation = true
    }
    
    func deleteContact() {
        chatManager.deleteContact(contact: contact) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Error deleting contact: \(error.localizedDescription)")
                } else {
                    self.onDismiss?()
                }
            }
        }
    }
    
    private func setupContactObserver() {
        chatManager.$contacts
            .compactMap { contactsArray in
                contactsArray.first { $0.id == self.initialContactID }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedContact in
                self?.contact = updatedContact
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
    
    var formattedPhoneNumber: String {
        return contact.phoneNumber.formattedBelgianPhoneNumber()
    }
    
    var contactName:String {
        return contact.name
    }
}
