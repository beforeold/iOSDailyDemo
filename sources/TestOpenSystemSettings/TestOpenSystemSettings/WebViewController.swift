//
//  WebViewController.swift
//  TestOpenSystemSettings
//
//  Created by beforeold on 2022/11/21.
//

import UIKit

import Foundation
import WebKit

class WebViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let webView = WKWebView(frame: .init(origin: .zero, size: .init(width: 300, height: 200)))
    view.addSubview(webView)
    
    let string = """
    <html><body>
<a href="prefs:root=General&path=STORAGE_MGMT">Visit W3Schools.com!</a>
    </body></html>
"""
    // prefs:root=General&path=STORAGE_MGMT
    // <html><body><p>Hello!</p></body></html>"
    webView.loadHTMLString(string, baseURL: nil)
  }
}
