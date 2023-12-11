//
//  DetailViewController.swift
//  16 capitalCities
//
//  Created by Taha Saleh on 10/20/22.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {

    var url : String?
    var webView = WKWebView()
    override func loadView() {
        view = webView
        webView.backgroundColor = .systemBackground
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: url!)!))
    }
   
}
