//
//  AppDelegate.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/20/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import Diagnostics
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        _ = UserNotificationCenter.shared.notificationsAllowed // request user authorization implicitly
        return true
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try DiagnosticsLogger.setup()
        } catch {
            Logger.log(message: "Failed to setup the Diagnostics Logger")
        }

        AppCenter.start(withAppSecret: "90a47855-7520-4d31-beb5-8ddb76fba052", services: [
            Analytics.self,
            Crashes.self,
        ])

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Remote Notification handling

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let devicdeId = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Logger.log(message: "Successful registration for push notification for deviceId \(devicdeId)")
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.log(error: error)
    }
}
