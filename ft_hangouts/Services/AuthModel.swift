//
//  FirebaseChatManager.swift
//  ft_hangouts
//
//  Created by William Deltenre on 08/10/2025.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseChatManager: ObservableObject {
    @Published var UID: String = ""
    @Published var verificationID: String? = nil
    @Published var verificationCode = ""
    @Published var phoneNumber = ""
    @Published var alertMessage: String? = nil
    @Published var isLoggedIn: Bool = false
    @Published var isUserDataLoaded: Bool = false
    @Published var colorThemeManager: ColorThemeManager = ColorThemeManager()
    @Published var localizationManager: LocalizationManager = LocalizationManager()
    
    @Published var currentUserData: UserData? {
        didSet {
            // This is executed every time currentUserData is updated.
            if currentUserData != nil {
                self.UID = currentUserData?.id ?? ""
                self.isUserDataLoaded = false
                print("currentUserData was set. Retrieving contacts and conversations.")
                self.retrieveContacts()
                self.isUserDataLoaded = true
            }
        }
    }
    @Published var conversations: [Conversation] = []
    @Published var contacts: [Contact] = []
    @Published var messages: [Message] = []
    @Published var selectedContact: Contact? = nil
    @Published var selectedConversationID: String = "" {
        didSet {
            if !selectedConversationID.isEmpty {
                self.retrieveMessages()
            }
        }
    }
    
    private var usersListener: ListenerRegistration?
    private var contactsListener: ListenerRegistration?
    private var conversationsListener: ListenerRegistration?
    private var messagesListener: ListenerRegistration?
    
    private let db = Firestore.firestore()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    weak var delegate: FirebaseChatDelegate?
    
    deinit {
        logOutCleanup()
    }
    
    func verifyPhoneNumber() {
        let phoneNumber = self.phoneNumber.filter { $0.isNumber || $0 == "+" }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            if let error = error {
                print("Error verifying phone number: \(error.localizedDescription)")
                self?.delegate?.didFailToLogin(with: error)
                self?.alertMessage = error.localizedDescription
                return
            }
            
            self?.alertMessage = nil
            self?.verificationID = verificationID
            self?.delegate?.didSendVerificationCode()
        }
    }
    
    func signIn() {
        guard let verificationID = self.verificationID else {
            print("Verification ID is missing.")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: self.verificationCode
        )
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                print("Error signing in with credential: \(error.localizedDescription)")
                self?.delegate?.didFailToLogin(with: error)
                self?.alertMessage = error.localizedDescription
                return
            }
            
            guard let user = authResult?.user else { return }
            print("Successfully signed in with user ID: \(user.uid)")
            self?.alertMessage = nil
            self?.isLoggedIn = true
            self?.retrieveUserData()
            self?.delegate?.didLogin(with: user)
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out of Firebase.")
            self.logOutCleanup()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func logOutCleanup() {
        usersListener?.remove()
        messagesListener?.remove()
        contactsListener?.remove()
        conversationsListener?.remove()
        
        conversations = []
        contacts = []
        messages = []
        selectedContact = nil
        selectedConversationID = ""
        
        verificationID = nil
        verificationCode = ""
        phoneNumber = ""
        alertMessage = nil
        isLoggedIn = false
        isUserDataLoaded = false
        
        localizationManager = LocalizationManager()
        colorThemeManager = ColorThemeManager()
        
        currentUserData = nil
        UID = ""
    }
    
    func retrieveUserData() {
        self.usersListener?.remove()
        
        let userRef = db.collection("users").document(self.currentUser!.uid)
        
        self.usersListener = userRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot else {
                print("Document does not exist or has no data.")
                return
            }
            
            if document.exists {
                do {
                    let userData = try document.data(as: UserData.self)
                    print("Successfully retrieved existing user data for UID: \(self.currentUser!.uid)")
                    DispatchQueue.main.async {
                        self.currentUserData = userData
                    }
                } catch {
                    print("Error decoding user data: \(error.localizedDescription)")
                    return
                }
            } else {
                print("User data not found for ID: \(self.currentUser!.uid). Creating a new document.")
                // If the document doesn't exist, create a new one.
                let phoneNumber = self.phoneNumber.filter { $0.isNumber || $0 == "+" }
                let newUser = UserData(phoneNumber: phoneNumber, contactsID: [])
                
                do {
                    try userRef.setData(from: newUser) { error in
                        if let error = error {
                            print("Error creating new document for user: \(error.localizedDescription)")
                            return
                        } else {
                            print("Successfully created new user document for UID: \(self.currentUser!.uid)")
                            
                            var updatedUser = newUser
                            updatedUser.id = self.currentUser!.uid
                            
                            DispatchQueue.main.async {
                                self.currentUserData = updatedUser
                            }
                        }
                    }
                } catch {
                    print("Error encoding new user data: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    // For this project, I can only have up to 5 conversations and contacts
    // If this is ever scaled .whereField(FieldPath.documentID(), in: ID) could reach its limit of 10 fetch at once
    // It will need to use chunks to fetch entries by 10
    func retrieveConversations() {
        self.conversationsListener?.remove()
        
        let conversationsID = contacts
            .compactMap { $0.conversationID }
            .filter { !$0.isEmpty }
        
        if conversationsID.isEmpty {
            self.conversations = []
            return
        }
        
        let conversationsQuery = db.collection("conversations")
            .whereField(FieldPath.documentID(), in: conversationsID)
        
        self.conversationsListener = conversationsQuery
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error listening for conversations: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.conversations = []
                    }
                    return
                }
                
                if querySnapshot?.metadata.hasPendingWrites == true {
                    print("Ignoring local update with pending server timestamp.")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    DispatchQueue.main.async {
                        self.conversations = []
                    }
                    return
                }
                
                let fetchedConversations = documents.compactMap { document -> Conversation? in
                    do {
                        print("Successfully retrieved conversations.")
                        return try document.data(as: Conversation.self)
                    } catch {
                        print("Error decoding conversation document: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                DispatchQueue.main.async {
                    self.conversations = fetchedConversations
                }
            }
    }
    
    func retrieveContacts() {
        self.contactsListener?.remove()
        
        guard let contactIDs = self.currentUserData?.contactsID, !contactIDs.isEmpty else {
            DispatchQueue.main.async {
                self.contacts = []
            }
            return
        }
        
        let contactsQuery = db.collection("contacts")
            .whereField(FieldPath.documentID(), in: contactIDs)
        
        self.contactsListener = contactsQuery.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching contacts: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.contacts = []
                }
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                DispatchQueue.main.async {
                    self.contacts = []
                }
                return
            }
            
            let fetchedContacts = documents.compactMap { document -> Contact? in
                do {
                    print("Successfully retrieved contacts.")
                    return try document.data(as: Contact.self)
                } catch {
                    print("Error decoding contact document: \(error.localizedDescription)")
                    return nil
                }
            }
            
            DispatchQueue.main.async {
                self.contacts = fetchedContacts
                self.retrieveConversations()
            }
        }
    }
    
    func retrieveMessages() {
        if self.selectedConversationID.isEmpty {
            print("No conversation selected")
            return
        }

        self.messagesListener?.remove()
        
        let messagesQuery = db.collection("messages")
            .whereField("conversationID", isEqualTo: self.selectedConversationID)
            .order(by: "timestamp", descending: false)
        
        self.messagesListener = messagesQuery.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error listening for messages: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Error retrieving messages: no documents")
                return
            }
            
            let fetchedMessages = documents.compactMap { document -> Message? in
                do {
                    print("Sucessfully mapped messages")
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding message document: \(error.localizedDescription)")
                    return nil
                }
            }
            
            DispatchQueue.main.async {
                print("Sucessfully retrieved messages")
                self.messages = fetchedMessages
            }
        }
    }
    
    func createConversation(contactPhoneNumber: String, completion: @escaping (String?) -> Void) {
        findID(phoneNumber: contactPhoneNumber) { contactID in
            guard !self.UID.isEmpty else {
                print("Error: Current user ID (UID) is empty.")
                completion(nil)
                return
            }
            let currentUserID = self.UID
            
            guard let contactID = contactID else {
                print("Error: Contact ID not found for phone number.")
                completion(nil)
                return
            }
            
            guard let selectedContactID = self.selectedContact?.id else {
                print("Error: Current UID or selectedContact ID is unavailable.")
                completion(nil)
                return
            }
            
            let usersID = [currentUserID, contactID].sorted()
            
            self.db.collection("conversations")
                .whereField("usersID", isEqualTo: usersID)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error querying conversations: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    if let document = snapshot?.documents.first {
                        let existingDocumentID = document.documentID
                        let batch = self.db.batch()
                        
                        let currentContactDocRef = self.db.collection("contacts").document(selectedContactID)
                        batch.updateData(["conversationID": existingDocumentID], forDocument: currentContactDocRef)
                        
                        batch.commit() { err in
                            if let err = err {
                                print("Error updating existing conversation ID on contact: \(err.localizedDescription)")
                                completion(nil)
                            } else {
                                print("Existing conversation linked successfully. ID: \(existingDocumentID)")
                                completion(existingDocumentID)
                            }
                        }
                        
                    } else {
                        let batch = self.db.batch()
                        
                        let conversationRef = self.db.collection("conversations").document()
                        let newConversationID = conversationRef.documentID
                        
                        let newConversation: [String: Any] = [
                            "messagesID": [],
                            "usersID": usersID,
                            "lastMessage": "",
                            "lastMessageSenderID": "",
                            "lastMessageTimestamp": ""
                        ]
                        
                        batch.setData(newConversation, forDocument: conversationRef)
                        
                        let currentContactDocRef = self.db.collection("contacts").document(selectedContactID)
                        batch.updateData(["conversationID": newConversationID], forDocument: currentContactDocRef)
                        
                        batch.commit() { err in
                            if let err = err {
                                print("Error creating new conversation and updating contact: \(err.localizedDescription)")
                                completion(nil)
                            } else {
                                print("New conversation created successfully with ID: \(newConversationID)")
                                completion(newConversationID)
                            }
                        }
                    }
                }
        }
    }
    
    func sendMessage(text: String) {
        guard !self.UID.isEmpty else {
            print("Error: Current user ID is missing.")
            return
        }
        let currentUserID = self.UID
        
        if self.selectedConversationID.isEmpty {
            print("Empty conversationID. Starting creation process...")
            
            self.createConversation(contactPhoneNumber: self.selectedContact!.phoneNumber) { conversationID in
                guard let newID = conversationID else {
                    print("Error: Failed to create new conversation. Message not sent.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.selectedConversationID = newID
                    self.executeMessageBatch(text: text, senderID: currentUserID)
                }
            }
            
        } else {
            self.executeMessageBatch(text: text, senderID: currentUserID)
        }
    }
    
    private func executeMessageBatch(text: String, senderID: String) {
        let timestamp = FieldValue.serverTimestamp()
        let messageData: [String : Any] = [
            "conversationID": self.selectedConversationID,
            "senderID": senderID,
            "text": text,
            "timestamp": timestamp
        ]
        
        let batch = self.db.batch()
        
        let messageRef = self.db.collection("messages").document()
        let messageID = messageRef.documentID
        
        batch.setData(messageData, forDocument: messageRef)
        
        let conversationRef = self.db.collection("conversations").document(self.selectedConversationID)
        batch.updateData([
            "messagesID": FieldValue.arrayUnion([messageID]),
            "lastMessage": text,
            "lastMessageSenderID": senderID,
            "lastMessageTimestamp": timestamp
        ], forDocument: conversationRef)
        
        findID(phoneNumber: self.selectedContact!.phoneNumber) { contactID in
            let contactsCollectionRef = self.db.collection("contacts")
            
            contactsCollectionRef
                .whereField("phoneNumber", isEqualTo: self.currentUserData!.phoneNumber.filter { $0.isNumber || $0 == "+" })
                .whereField("userID", isEqualTo: contactID ?? "")
                .limit(to: 1)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error checking contact existence: \(error.localizedDescription)")
                        return
                    }
                    
                    if let existingDocument = snapshot?.documents.first {
                        let existingDocID = existingDocument.documentID
                        let contactRef = self.db.collection("contacts").document(existingDocID)
                        
                        batch.updateData(["conversationID": self.selectedConversationID], forDocument: contactRef)
                        
                    } else {
                        let contactsCollectionRef = self.db.collection("contacts")
                        let newContactRef = contactsCollectionRef.document()
                        
                        let newContactData = [
                            "userID": contactID!,
                            "name": self.currentUserData!.phoneNumber.filter { $0.isNumber || $0 == "+" },
                            "phoneNumber": self.currentUserData!.phoneNumber.filter { $0.isNumber || $0 == "+" },
                            "conversationID": self.selectedConversationID,
                            "imageData": Data()
                        ] as [String : Any]
                        
                        batch.setData(newContactData, forDocument: newContactRef)
                        
                        let usersRef = self.db.collection("users").document(contactID!)
                        batch.updateData(["contactsID": FieldValue.arrayUnion([newContactRef.documentID])], forDocument: usersRef)
                    }
                    batch.commit() { error in
                        if let error = error {
                            print("Error sending message and updating conversation: \(error.localizedDescription)")
                        } else {
                            print("Message and conversation updated successfully.")
                        }
                    }
                }
        }
    }
    
    func findID(phoneNumber: String, completion: @escaping (String?) -> Void) {
        let filteredPhoneNumber = phoneNumber.filter { $0.isNumber || $0 == "+" }
        db.collection("users")
            .whereField("phoneNumber", isEqualTo: filteredPhoneNumber)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error finding user for phone number: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let document = querySnapshot?.documents.first {
                    completion(document.documentID)
                } else {
                    print("No user found with phone number: \(filteredPhoneNumber)")
                    completion(nil)
                }
            }
    }
    
    func findConversation(contactID: String, completion: @escaping (String?) -> Void) {
        let conversationRef = db.collection("conversations")
        
        conversationRef
            .whereField("usersID", isEqualTo: [contactID, self.UID].sorted())
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error checking contact existence: \(error.localizedDescription)")
                    return
                }
                
                if let existingDocument = snapshot?.documents.first {
                    completion(existingDocument.documentID)
                } else {
                    completion(nil)
                }
            }
    }
    
    
    func saveContact(contact: Contact, completion: @escaping (Error?) -> Void) {
        let contactsRef = db.collection("contacts")
        
        findID(phoneNumber: contact.phoneNumber) { contactID in
            guard contactID != nil else {
                let localizedMessage = "ERROR_NO_PHONE_ID".localized(using: self.localizationManager)
                let error = NSError(
                    domain: "FirebaseChatManagerError",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: localizedMessage]
                )
                completion(error)
                return
            }
            
            self.findConversation(contactID: contactID!) { conversationID in
                contactsRef
                    .whereField("phoneNumber", isEqualTo: contact.phoneNumber.filter { $0.isNumber || $0 == "+" })
                    .whereField("userID", isEqualTo: self.UID)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error checking for duplicate number: \(error.localizedDescription)")
                            completion(error)
                            return
                        }
                        
                        let batch = self.db.batch()
                        
                        let contactData = [
                            "userID": self.UID,
                            "name": contact.name,
                            "phoneNumber": contact.phoneNumber.filter { $0.isNumber || $0 == "+" },
                            "conversationID": conversationID ?? "",
                            "imageData": contact.imageData ?? Data()
                        ] as [String : Any]
                        
                        let currentUserRef = self.db.collection("users").document(self.UID)
                        
                        if let documents = querySnapshot?.documents, !documents.isEmpty {
                            let documentToEdit = documents[0].reference
                            batch.updateData(contactData, forDocument: documentToEdit)
                            print("Contact document with ID \(documentToEdit.documentID) updated in batch.")
                        } else {
                            let newContactRef = contactsRef.document()
                            batch.setData(contactData, forDocument: newContactRef)
                            print("New contact document with ID \(newContactRef.documentID) added to batch.")
                            
                            batch.updateData(["contactsID": FieldValue.arrayUnion([newContactRef.documentID])], forDocument: currentUserRef)
                        }
                        
                        batch.commit { error in
                            if let error = error {
                                print("Error committing batch operation: \(error.localizedDescription)")
                                completion(error)
                            } else {
                                print("Contact save operation successful!")
                                completion(nil)
                            }
                        }
                    }
            }
        }
    }
    
    func deleteContact(contact: Contact, completion: @escaping (Error?) -> Void) {
        guard let contactID = contact.id else {
            let localizedMessage = "MISSING_IDS".localized(using: self.localizationManager)
            completion(NSError(
                domain: "ChatManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: localizedMessage]
            ))
            return
        }
        
        let batch = self.db.batch()
        
        let contactRef = db.collection("contacts").document(contactID)
        batch.deleteDocument(contactRef)
        
        let usersRef = db.collection("users").document(self.UID)
        batch.updateData(["contactsID": FieldValue.arrayRemove([contactID])], forDocument: usersRef)
        
        batch.commit(completion: completion)
        return
    }
}

protocol FirebaseChatDelegate: AnyObject {
    func didLogin(with user: User)
    func didFailToLogin(with error: Error)
    func didSendVerificationCode()
}
