//
//  DetailViewController.swift
//  7 white house petition
//
//  Created by Taha Saleh on 6/12/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController
{
    var webView : WKWebView!
    var petition : Petition?
    override func loadView() {
        webView = WKWebView()
        self.view = webView
        webView.backgroundColor = .systemBackground
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        webView.loadHTMLString(getHTML(), baseURL: nil)
        
    }
    func getHTML()->String
    {
        guard let detailItem = petition else {return "no body"}
        let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style> body {font-size:150%;} </style>
            </head>
            <body>
            <h1> </h1>
            <p>\(detailItem.body).</p>
            </body>
            </html>
            """
        return html
    }
}
