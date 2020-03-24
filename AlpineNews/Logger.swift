//
//  Logger.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/22/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Foundation
import Diagnostics
import AppCenterAnalytics

struct Logger {

    static func log(message: String) {
        DiagnosticsLogger.log(message: message)
    }

    static func log(error: Error) {
        DiagnosticsLogger.log(error: error)
    }

    static func trackEvent(_ eventName: String) {
        MSAnalytics.trackEvent(eventName)
    }

    static func trackVieWebSiteEvent(_ resourceUrl: URL) {
        MSAnalytics.trackEvent("View WebSite", withProperties: ["url":resourceUrl.absoluteString])
        self.log(message: "View WebSite \(resourceUrl.absoluteString)")
    }
}
