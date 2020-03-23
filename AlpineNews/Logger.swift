//
//  Logger.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/22/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Foundation
import Diagnostics

struct Logger {

    static func log(message: String) {
        DiagnosticsLogger.log(message: message)
    }

    static func log(error: Error) {
        DiagnosticsLogger.log(error: error)
    }
}
