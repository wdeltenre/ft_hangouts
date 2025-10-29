//
//  NetworkUnavailableView.swift
//  ft_hangouts
//
//  Created by William Deltenre on 25/10/2025.
//

import SwiftUI

struct NetworkUnavailableView: View {
    @ObservedObject var chatManager: FirebaseChatManager
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
                .opacity(0.95)
            
            VStack(spacing: 20) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                
                Text("CONNECTION_LOST".localized(using: chatManager.localizationManager))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("CHECK_NETWORK".localized(using: chatManager.localizationManager))
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button(action: {print("Retrying to connect...")}) {
                    Text("RETRY_CONNECTION".localized(using: chatManager.localizationManager))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
            }
            .padding(40)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .shadow(radius: 10)
        }
        .opacity(1)
    }
}
