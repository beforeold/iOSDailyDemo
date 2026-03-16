//
//  WebView.swift
//  DemoYoutubeView
//
//  Created by Codex on 3/16/26.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  let url: URL?

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIView(context: Context) -> WKWebView {
    let configuration = WKWebViewConfiguration()
    configuration.allowsInlineMediaPlayback = false
    configuration.mediaTypesRequiringUserActionForPlayback = []

    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = context.coordinator
    webView.scrollView.contentInsetAdjustmentBehavior = .never
    webView.allowsBackForwardNavigationGestures = true
    webView.backgroundColor = .black
    webView.isOpaque = false
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    guard let url else { return }

    if webView.url != url {
      webView.load(makeRequest(for: url))
    }
  }

  private func makeRequest(for url: URL) -> URLRequest {
    var request = URLRequest(url: url)

    if let bundleIdentifier = Bundle.main.bundleIdentifier?.lowercased() {
      let referer = "https://\(bundleIdentifier)"
      request.setValue(referer, forHTTPHeaderField: "Referer")
    }

    return request
  }
}

final class Coordinator: NSObject, WKNavigationDelegate {
  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    print("WKWebView provisional navigation failed: \(error.localizedDescription)")
  }

  func webView(
    _ webView: WKWebView,
    didFail navigation: WKNavigation!,
    withError error: Error
  ) {
    print("WKWebView navigation failed: \(error.localizedDescription)")
  }
}
