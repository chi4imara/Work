import SwiftUI
@preconcurrency import WebKit

struct PosterDisplay: UIViewRepresentable {
    let url: String
    let viewModel: DrawViewModel
    private let customUserAgent = defaultUserAgent()
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(
            frame: .zero,
            configuration: buildConfiguration()
        )
        initializeWebView(webView, coordinator: context.coordinator)
        loadURL(webView)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.performRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .black
        webView.scrollView.refreshControl = refreshControl
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func buildConfiguration() -> WKWebViewConfiguration {
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
    
    private func initializeWebView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.navigationDelegate = coordinator
        webView.customUserAgent = customUserAgent
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func loadURL(_ webView: WKWebView) {
        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func reload(_ webView: WKWebView) {
        webView.reload()
    }
    
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let container: PosterDisplay
        
        init(_ container: PosterDisplay) {
            self.container = container
        }
        
        @objc func performRefresh(_ sender: UIRefreshControl) {
            if let webView = sender.superview(of: WKWebView.self) {
                container.reload(webView)
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
            LeaderboardStarChaser.shared.checkAndRequestReview()
        }
        
        private func processUrl(_ url: URL) {
            storeLink()
        }
        
        private func storeLink() {
            LocalStorage.shared.text = container.viewModel.hasParameter ? "" : container.url
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

private func defaultUserAgent() -> String {
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
