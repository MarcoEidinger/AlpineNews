//
//  NewsWebDetails.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/20/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI

struct ResourceWebViewer: View {
    @ObservedObject var webViewStore = WebViewStore()
    let url: URL
    @State var showActivitySheet = false
    var body: some View {
        //        WebView(webView: webViewStore.webView)
        //        .navigationBarItems(trailing: HStack {
        //            Button(action: {
        //                UIApplication.shared.open(self.url, options: [:], completionHandler: nil)
        //            }) {
        //            Text("Open in browser")
        //          }
        //        })
        //        .onAppear {
        //            self.webViewStore.webView.load(URLRequest(url: self.url))
        //        }

        SimpleWebView(url: url)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    UIApplication.shared.open(self.url, options: [:], completionHandler: nil)
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .accessibility(label: Text("Open in Browser"))
                }
                .padding()

                Button(action: {
                    self.showActivitySheet.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .accessibility(label: Text("Share"))
                }
                .sheet(isPresented: $showActivitySheet) {
                    ActivityView(url: self.url.absoluteString, showing: self.$showActivitySheet)
                }
                .padding()
            })
    }
}

struct NewsWebDetails_Previews: PreviewProvider {
    static var previews: some View {
        ResourceWebViewer(url: URL(string: "https://www.google.com")!)
    }
}
