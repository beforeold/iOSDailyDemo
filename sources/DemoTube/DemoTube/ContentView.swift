import SwiftUI
import WebKit

struct ContentView: View {
    @State private var inputUrl: String = ""
    @State private var videoId: String?
    @State private var showScanner = false
    
    var body: some View {
        VStack {
            // Normales TextField mit vollem Kontextmenü (inkl. Paste)
            TextField("YouTube-URL eingeben", text: $inputUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Video anzeigen") {
                    videoId = extractVideoID(from: inputUrl)
                }
                .padding()
                
                Button("QR-Code scannen") {
                    showScanner = true
                }
                .padding()
            }
            
            if let videoId = videoId {
                YouTubeWebView(url: URL(string: "https://www.youtube-nocookie.com/embed/\(videoId)?rel=0&modestbranding=1&controls=1")!)
                    .frame(minHeight: 300)
            }
        }
        .sheet(isPresented: $showScanner) {
            QRScannerView(scannedCode: $inputUrl, isPresented: $showScanner) {
                videoId = extractVideoID(from: inputUrl)
            }
        }
        .padding()
    }
    
    func extractVideoID(from url: String) -> String? {
        if let id = URLComponents(string: url)?
            .queryItems?.first(where: { $0.name == "v" })?.value {
            return id
        }
        
        if let shortId = URL(string: url)?.lastPathComponent, shortId.count == 11 {
            return shortId
        }
        
        return nil
    }
}

// MARK: - WebView mit deaktivierter Interaktion/Kopierfunktion
struct YouTubeWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = true
        
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let disableInteractionsJS = """
            document.documentElement.style.webkitUserSelect='none';
            document.documentElement.style.webkitTouchCallout='none';

            document.querySelectorAll('a').forEach(a => {
                a.onclick = function(e) { e.preventDefault(); return false; };
                a.removeAttribute('href');
                a.draggable = false;
                a.addEventListener('dragstart', e => e.preventDefault());
            });

            document.addEventListener('dragstart', e => e.preventDefault());
            """
            webView.evaluateJavaScript(disableInteractionsJS, completionHandler: nil)

        }
    }
}
