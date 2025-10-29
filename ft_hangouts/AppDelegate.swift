//
//  AppDelegate.swift
//  ft_hangouts
//
//  Created by William Deltenre on 07/10/2025.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)

        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            if Auth.auth().canHandleNotification(userInfo) {
                completionHandler(.noData)
                return
            }
        
            completionHandler(.noData)
        }
}
