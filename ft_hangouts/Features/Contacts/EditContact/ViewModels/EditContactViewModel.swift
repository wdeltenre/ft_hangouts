//
//  EditContactViewModel.swift
//  ft_hangouts
//
//  Created by William Deltenre on 15/10/2025.
//

import Foundation
import Combine

final class EditContactViewModel: ObservableObject {
    @Published var localizationManager: LocalizationManager
    @Published var contact: Contact
    
    @Published var showAlert: Bool = false
    @Published var showSuccessMessage: Bool = false
    @Published var emptyName: Bool = false
    @Published var emptyPhoneNumber: Bool = false
    @Published var showingImagePicker = false
    
    private let chatManager: FirebaseChatManager
    private var cancellables = Set<AnyCancellable>()
    
    private let initialContactID: String
    
    var onDismiss: (() -> Void)?
    
    init(chatManager: FirebaseChatManager, contact: Contact) {
        self.chatManager = chatManager
        
        self.contact = contact
        self.localizationManager = chatManager.localizationManager
        
        self.initialContactID = contact.id ?? ""
        
        self.setupLocalizationBinding()
        self.setupContactObserver()
    }
    
    func formatPhoneNumber() {
        contact.phoneNumber = contact.phoneNumber.formattedBelgianPhoneNumber()
    }
    
    func saveContactAction() {
        emptyName = false
        emptyPhoneNumber = false
        
        let trimmedName = contact.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = contact.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let isNameValid = !trimmedName.isEmpty
        let isPhoneValid = !trimmedPhone.isEmpty
        
        if !isNameValid || !isPhoneValid {
            emptyName = !isNameValid
            emptyPhoneNumber = !isPhoneValid
            return
        }
        
        var contactToSave = contact
        contactToSave.name = trimmedName
        contactToSave.phoneNumber = trimmedPhone
        
        chatManager.saveContact(contact: contactToSave) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to save contact: \(error)")
                self.showAlert = true
            } else {
                self.showSuccessMessage = true
                self.contact = contactToSave
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showSuccessMessage = false
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
}
