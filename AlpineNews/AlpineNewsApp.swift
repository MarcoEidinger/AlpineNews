//
//  AlpineNewsApp.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 9/10/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

@main
struct AlpineNewsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(DataModel())
        }
    }
}
