//
//  ActivityView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/21/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    var url: String
    @Binding var showing: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(
            activityItems: [NSURL(string: url)!],
            applicationActivities: nil
        )
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.showing = false
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
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
                    ActivityView(url: "https://www.wikipedia.org", showing: self.$showSheet)
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
