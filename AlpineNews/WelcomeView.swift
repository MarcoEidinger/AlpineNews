//
//  WelcomeView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/28/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("swift-large")
                .resizable()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.gray))

            HStack(spacing: 20) {
                Image(systemName: "tray")
                Text("Keep up-to-date with the latest news in Swift,\n iOS development and the Apple ecosystem")
            }
            .padding()
            HStack(spacing: 20) {
                Image(systemName: "book")
                Text("Add interesting material to your library")
            }
            .padding()
            HStack(spacing: 20) {
                Image(systemName: "gear")
                Text("Get reminders and provide feedback")
            }
            .padding()
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
