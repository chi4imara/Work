import SwiftUI
@preconcurrency import WebKit

struct BrowserView: UIViewRepresentable {
    let url: String
    let viewModel: RemoteViewModel
    private let customUserAgent = generateUserAgent()
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(
            frame: .zero,
            configuration: createConfiguration()
        )
        configureWebView(webView, coordinator: context.coordinator)
        loadInitialUrl(webView)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .black
        webView.scrollView.refreshControl = refreshControl
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func createConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = prefs
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        return configuration
    }
    
    private func configureWebView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.navigationDelegate = coordinator
        webView.customUserAgent = customUserAgent
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func loadInitialUrl(_ webView: WKWebView) {
        guard let linkURL = URL(string: url) else { return }
        webView.load(URLRequest(url: linkURL))
    }
    
    private func reload(_ webView: WKWebView) {
        webView.reload()
    }
    
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: BrowserView
        
        init(_ parent: BrowserView) {
            self.parent = parent
        }
        
        @objc func handleRefresh(_ sender: UIRefreshControl) {
            if let webView = sender.superview(of: WKWebView.self) {
                parent.reload(webView)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                sender.endRefreshing()
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            navigationAction.request.url.map(processUrl)
            decisionHandler(shouldAllowNavigation(navigationAction))
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            AppRatingManager.shared.checkAndRequestReview()
        }
        
        private func processUrl(_ url: URL) {
            updateStoredLink()
        }
        
        private func updateStoredLink() {
            LocalStorage.shared.savedLink = parent.viewModel.hasParameter ? "" : parent.url
        }
        
        private func shouldAllowNavigation(_ navigationAction: WKNavigationAction) -> WKNavigationActionPolicy {
            guard let url = navigationAction.request.url, let scheme = url.scheme else {
                return .allow
            }
            
            let externalSchemes = ["tel", "mailto", "tg", "phonepe", "paytmmp"]
            if externalSchemes.contains(scheme) {
                UIApplication.shared.open(url)
                return .cancel
            }
            return .allow
        }
    }
}

private func generateUserAgent() -> String {
    let device = UIDevice.current
    let osVersion = device.systemVersion.replacingOccurrences(of: ".", with: "_")
    
    return """
    Mozilla/5.0 (\(device.model); CPU \(device.model) OS \(osVersion) like Mac OS X) \
    AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(device.systemVersion) Mobile/15E148 Safari/604.1
    """
}

extension UIView {
    func superview<T: UIView>(of type: T.Type) -> T? {
        if let view = self as? T {
            return view
        }
        return superview?.superview(of: type)
    }
}
