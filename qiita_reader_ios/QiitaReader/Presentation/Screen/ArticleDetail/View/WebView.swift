//
//  WebView.swift
//  QiitaReader
//
//  Created by Shusuke Ota on 2025/2/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var isLoading: Bool

    let articleUrl: URL

    func makeUIView(context: Context) -> WKWebView {
        let request = URLRequest(url: articleUrl)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
    }
}

class Coordinator: NSObject, WKNavigationDelegate {
    private let owner: WebView

    init(owner: WebView) {
        self.owner = owner
        super.init()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        owner.isLoading = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        owner.isLoading = false
    }
}

#Preview {
    WebView(isLoading: .constant(false), articleUrl: URL(string: "https://developer.apple.com/jp/")!)
}
