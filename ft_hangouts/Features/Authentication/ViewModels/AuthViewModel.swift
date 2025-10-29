//
//  AuthViewModel.swift
//  ft_hangouts
//
//  Created by William Deltenre on 20/10/2025.
//

import Combine
import Foundation

final class AuthViewModel: ObservableObject {
    @Published var localizationManager: LocalizationManager
    
    @Published var phoneNumber: String
    @Published var verificationCode: String
    @Published var verificationID: String?
    
    @Published var isLanguageExpanded: Bool = false
    
    private let chatManager: FirebaseChatManager
    private var cancellables = Set<AnyCancellable>()
    
    init(chatManager: FirebaseChatManager) {
        self.chatManager = chatManager
        
        self.localizationManager = chatManager.localizationManager
        
        self.phoneNumber = chatManager.phoneNumber
        self.verificationCode = chatManager.verificationCode
        self.verificationID = chatManager.verificationID
        
        self.setupLocalizationBinding()
        self.setupBindings()
    }
    
    func verifyPhoneNumber() {
        chatManager.verifyPhoneNumber()
    }
    
    func signIn() {
        chatManager.signIn()
    }
    
    func formatPhoneNumber() {
        phoneNumber = phoneNumber.formattedBelgianPhoneNumber()
    }
    
    private func setupBindings() {
        $phoneNumber
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPhoneNumber in
                self?.chatManager.phoneNumber = newPhoneNumber
            }
            .store(in: &cancellables)
        
        $verificationCode
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newCode in
                self?.chatManager.verificationCode = newCode
            }
            .store(in: &cancellables)
        
        chatManager.$verificationID
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$verificationID)
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
