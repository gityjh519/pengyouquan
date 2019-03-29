//
//  JHSHTMLViewController.swift
//  PenGroup
//
//  Created by yaojinhai on 2019/3/28.
//  Copyright © 2019年 yaojinhai. All rights reserved.
//

import UIKit
import WebKit

class JHSHTMLViewController: JHSBaseViewController ,WKNavigationDelegate{

    var webView: WKWebView!
    var urlString: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = urlString;

        let config = WKWebViewConfiguration();
        config.allowsAirPlayForMediaPlayback = true;
        config.preferences = WKPreferences();
        config.preferences.javaScriptEnabled = true;
        webView = WKWebView(frame: bounds(), configuration: config);
        addSubview(subView: webView);
        
        webView.navigationDelegate = self;
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil);
        
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newTitle = change?[NSKeyValueChangeKey.newKey] as? String {
            self.title = newTitle;
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        guard let url = urlString,
            let tempURL = URL(string: url) else {
            return;
        }
        webView.load(URLRequest(url: tempURL));
        
    }
    

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
    }
   
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
    }

}
