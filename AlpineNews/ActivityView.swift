//
//  ActivityView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/21/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    var url: String
    var title: String?
    var saveAPI: DataModelSaveAPI
    @Binding var showing: Bool

    func makeUIViewController(context _: Context) -> UIActivityViewController {
        let act: UIActivity = AddToAppLibraryActivity(saveAPI: saveAPI)
        let actItem = AddToAppLibraryItem(url: URL(string: url)!, title: title)
        let vc = UIActivityViewController(
            activityItems: [NSURL(string: url)!, actItem],
            applicationActivities: [act]
        )
        vc.completionWithItemsHandler = { _, _, _, _ in
            self.showing = false
        }
        return vc
    }

    func updateUIViewController(_: UIActivityViewController, context _: Context) {}
}

struct TestUIActivityView: View {
    @State var showSheet = false

    var body: some View {
        ScrollView {
            Group {
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    Text("Open Activity View")
                }
                .sheet(isPresented: $showSheet) {
                    ActivityView(url: "https://www.wikipedia.org", saveAPI: DataModel(), showing: self.$showSheet)
                }
            }
        }
    }
}

struct TestUIActivityView_Previews: PreviewProvider {
    static var previews: some View {
        TestUIActivityView()
    }
}
