import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView navigation failed: \(error.localizedDescription)")
        }
    }
}

struct WebViewContainer: View {
    let urlString: String
    let title: String
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                WebView(urlString: urlString)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    WebViewContainer(urlString: "https://google.com", title: "Privacy Policy")
}
