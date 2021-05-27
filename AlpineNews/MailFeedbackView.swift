//
//  MailFeedbackView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/22/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import Diagnostics
import MessageUI
import SwiftUI
import UIKit

struct MailFeedbackView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>)
        {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?)
        {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailFeedbackView>) -> MFMailComposeViewController {
        Logger.trackEvent("User wants to provide feedback")

        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["eidingermarco@gmail.com"])
        vc.setSubject("Feedback for Swift News")
        vc.setMessageBody("I would like to ...", isHTML: false)

        let report = DiagnosticsReporter.create()
        vc.addDiagnosticReport(report)

        return vc
    }

    func updateUIViewController(_: MFMailComposeViewController,
                                context _: UIViewControllerRepresentableContext<MailFeedbackView>) {}
}
