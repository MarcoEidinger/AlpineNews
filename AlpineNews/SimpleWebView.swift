//
//  SimpleWebView.swift
//  AlpineNews
//
//  Created by Eidinger, Marco on 3/20/20.
//  Copyright © 2020 Eidinger, Marco. All rights reserved.
//

import SwiftUI
import WebKit

class WKNavigationDelegateImp: NSObject, WKNavigationDelegate {
    func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        Logger.log(error: error)
    }

    func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        Logger.log(error: error)
    }
}

struct SimpleWebView: UIViewRepresentable {
    let url: URL
    var delegate = WKNavigationDelegateImp()

    static var cache = [URL: WKWebView]()
    static var cacheTime = [URL: Date]()

    func makeUIView(context _: Context) -> WKWebView {
        if let webView = SimpleWebView.cache[url] {
            if let cacheDate = SimpleWebView.cacheTime[url] {
                let diffTime = Date().timeIntervalSince(cacheDate)
                if diffTime < 600 { // cache good upt to 10 min
                    return webView
                }
                SimpleWebView.cache.removeValue(forKey: url)
                SimpleWebView.cacheTime.removeValue(forKey: url)
            }
        }

        let webView = WKWebView()
        webView.navigationDelegate = delegate

        SimpleWebView.cache[url] = webView
        SimpleWebView.cacheTime[url] = Date()

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        uiView.load(URLRequest(url: url))
    }
}
