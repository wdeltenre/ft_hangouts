//
//  ft_hangoutsApp.swift
//  ft_hangouts
//
//  Created by William Deltenre on 09/10/2025.
//

import SwiftUI

@main
struct ft_hangoutsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var chatManager = FirebaseChatManager()
    
    @StateObject private var networkMonitor = NetworkMonitor()
    @AppStorage("lastBackgroundDateKey") private var lastBackgroundDateData: Double?
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var showToast: Bool = false
    @State private var lastBackgroundText: String = ""
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if chatManager.isLoggedIn && chatManager.isUserDataLoaded {
                    ConversationListView(chatManager: chatManager)
                } else if chatManager.isLoggedIn {
                    ProgressView("LOADING_DATA".localized(using: chatManager.localizationManager))
                        .onAppear {
                            chatManager.retrieveUserData()
                        }
                } else {
                    // When the user is logged out, this is the root view.
                    AuthView(chatManager: chatManager)
                }
            }
            .overlay(alignment: .top) {
                if showToast {
                    TimeToastView(
                        message: lastBackgroundText
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            
            .onChange(of: scenePhase) { oldPhase, newPhase in
                handleScenePhaseChange(newPhase: newPhase)
            }
            
            .blur(radius: networkMonitor.isConnected ? 0 : 5)
            .animation(.easeInOut, value: networkMonitor.isConnected)
            
            if !networkMonitor.isConnected {
                NetworkUnavailableView(chatManager: chatManager)
                    .transition(.opacity)
            }
        }
    }
    
    private func handleScenePhaseChange(newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            lastBackgroundDateData = Date().timeIntervalSince1970
            
        case .active:
            guard let timestamp = lastBackgroundDateData, timestamp > 0 else {
                return
            }
            
            let lastDate = Date(timeIntervalSince1970: timestamp)
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            
            let timeString = formatter.string(from: lastDate)
            
            lastBackgroundText = "LAST_BG_TIME".localized(using: chatManager.localizationManager, arguments: timeString)
            showToast = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut) {
                    showToast = false
                }
            }
            
        case .inactive:
            break
        @unknown default:
            break
        }
    }
}
