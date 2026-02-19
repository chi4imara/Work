import StoreKit
import SwiftUI
import Combine

class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    
    private init() {}
    
    @MainActor
    func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    func openAppStore() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}
