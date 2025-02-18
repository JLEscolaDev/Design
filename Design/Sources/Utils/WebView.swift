//
//  WebView.swift
//  Design
//
//  Created by Jose Luis Escolá García on 30/11/24.
//

import SwiftUI
import WebKit

class WebViewPreloader {
    static let shared = WebViewPreloader()
    var preloadedWebView: WKWebView

    private init() {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = WKProcessPool() // Shared process pool for optimization
        preloadedWebView = WKWebView(frame: .zero, configuration: configuration)
        preloadedWebView.load(URLRequest(url: URL(string: "about:blank")!))
    }
}

#if os(iOS)
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WebViewPreloader.shared.preloadedWebView
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
#elseif os(macOS)
struct WebView: NSViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool

    func makeNSView(context: Context) -> WKWebView {
        let webView = WebViewPreloader.shared.preloadedWebView
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
#endif

// Shared Coordinator
class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView

    init(_ parent: WebView) {
        self.parent = parent
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        parent.isLoading = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.isLoading = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        parent.isLoading = false
    }
}
