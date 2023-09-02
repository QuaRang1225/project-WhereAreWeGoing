//
//  LinkWebView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/09/02.
//

import Foundation
import SwiftUI
import WebKit

struct LinkWebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: LinkWebView
        
        init(_ parent: LinkWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 웹 페이지 로딩이 완료되었을 때 추가 작업을 수행할 수 있습니다.
        }
    }
}
