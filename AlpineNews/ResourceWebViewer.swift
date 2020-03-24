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

        WebView(webView: webViewStore.webView)
            .frame(height: UIScreen.main.bounds.height-120)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    UIApplication.shared.open(self.webViewStore.webView.url ?? self.url, options: [:], completionHandler: nil)
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
                    ActivityView(url: self.webViewStore.webView.url?.absoluteString ?? self.url.absoluteString, showing: self.$showActivitySheet)
                }
                .padding()
            })
            .onAppear {
                self.webViewStore.webView.load(URLRequest(url: self.url))
        }

        //        SimpleWebView(url: url)
        //            .frame(height: UIScreen.main.bounds.height-120)
        //            .navigationBarItems(trailing: HStack {
        //                Button(action: {
        //                    UIApplication.shared.open(self.url, options: [:], completionHandler: nil)
        //                }) {
        //                    Image(systemName: "arrow.up.left.and.arrow.down.right")
        //                        .accessibility(label: Text("Open in Browser"))
        //                }
        //                .padding()
        //
        //                Button(action: {
        //                    self.showActivitySheet.toggle()
        //                }) {
        //                    Image(systemName: "square.and.arrow.up")
        //                        .accessibility(label: Text("Share"))
        //                }
        //                .sheet(isPresented: $showActivitySheet) {
        //                    ActivityView(url: self.url.absoluteString, showing: self.$showActivitySheet)
        //                }
        //                .padding()
        //            })
    }
}

struct NewsWebDetails_Previews: PreviewProvider {
    static var previews: some View {
        ResourceWebViewer(url: URL(string: "https://www.google.com")!)
    }
}
