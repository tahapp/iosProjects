//
//  ViewController.swift
//  4 Easy Browser
//
//  Created by Taha Saleh on 5/9/22.
//

import UIKit
import WebKit

final class ViewController: UIViewController
{
    
    private let webView = WKWebView()
    private let webProgress = UIProgressView(progressViewStyle: .default)
    private let secureWebsites = ["google","apple","hackingwithswift"]
    override func loadView()
    {
       
        view = webView
        webView.navigationDelegate = self
        let url = URL(string: "https://www.google.com")!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let space = UIBarButtonItem(systemItem: .flexibleSpace)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let progress = UIBarButtonItem(customView: webProgress)
        webProgress.sizeToFit()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open", style: .plain, target: self, action: #selector(open))
        navigationController?.isToolbarHidden = false
        toolbarItems  = [progress,space,refresh]
    }

    @objc func open()
    {
        let alertController = UIAlertController(title: "choose website", message: nil, preferredStyle: .actionSheet)
        for index in 1...2
        {
            let action = UIAlertAction(title: secureWebsites[index], style: .default, handler: launch(action:))
            alertController.addAction(action)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    func launch(action : UIAlertAction)
    {
        guard let url = URL(string: "https://www.\(action.title!).com")else{
            print("can't ")
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"
        {
            webProgress.progress = Float(webView.estimatedProgress)
        }
    }
   
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if let url = navigationAction.request.url,
           let host = url.host{
            for website in secureWebsites
            {
                if host.contains(website)
                {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
}

