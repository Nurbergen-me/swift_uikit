//
//  WebViewController.swift
//  Project16
//
//  Created by Nurbergen Yeleshov on 14.01.2021.
//

import WebKit
import UIKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var selectedCity: String?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wikipedia"

        let url = URL(string: "http://en.wikipedia.org/wiki/" + selectedCity!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

}
