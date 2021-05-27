//
//  FeedbackSettingsView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/22/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import MessageUI
import SwiftUI

struct FeedbackSettingsView: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false

    var body: some View {
        Section(header: Text("Feedback")) {
            Button(action: {
                self.isShowingMailView.toggle()
            }) {
                HStack {
                    Spacer()
                    Text("Send your feedback to developer")
                    Spacer()
                }
            }
            .multilineTextAlignment(.center)
            .disabled(!MFMailComposeViewController.canSendMail())
            .sheet(isPresented: $isShowingMailView) {
                MailFeedbackView(result: self.$result)
            }
        }
    }
}

struct FeedbackSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackSettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
    }
}
