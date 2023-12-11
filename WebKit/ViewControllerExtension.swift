//
//  ViewControllerExtension.swift
//  4 Easy Browser
//
//  Created by Taha Saleh on 5/9/22.
//

import WebKit

extension ViewController : WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        
    }
}
