//
//  CustomWebView.swift
//  GithubApiPlayground
//
//  Created by Ethan Wen on 2024/8/29.
//

import SwiftUI
import WebKit

struct CustomWebView: UIViewRepresentable {
    var urlString: String
    var didFinishHandler: ((WKNavigation) -> ())?
    var didStartHandler: ((WKNavigation) -> ())?
    @Binding var webView: WKWebView?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            uiView.load(URLRequest(url: url))
            return
        }
        print("url is invalid")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

class Coordinator: NSObject, WKNavigationDelegate {
    var parent: CustomWebView
    
    init(parent: CustomWebView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.parent.webView = webView
        if let didFinishHandler = parent.didFinishHandler {
            didFinishHandler(navigation)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let didStartHandler = parent.didStartHandler {
            didStartHandler(navigation)
        }
    }
}
