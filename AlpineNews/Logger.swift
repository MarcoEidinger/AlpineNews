//
//  Logger.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/22/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import Diagnostics
import Foundation

struct Logger {
    static func log(message: String) {
        DiagnosticsLogger.log(message: message)
    }

    static func log(error: Error) {
        DiagnosticsLogger.log(error: error)
    }

    static func trackEvent(_ eventName: String) {
        Analytics.trackEvent(eventName)
    }

    static func trackVieWebSiteEvent(_ resourceUrl: URL) {
        Analytics.trackEvent("View WebSite", withProperties: ["url": resourceUrl.absoluteString])
        log(message: "View WebSite \(resourceUrl.absoluteString)")
    }
}
