import Foundation
import SwiftUI
import StoreKit
import Combine

class SettingsViewModel: ObservableObject {
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/39459923-acc9-4d81-976a-c1c143076eda") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://www.termsfeed.com/live/39459923-acc9-4d81-976a-c1c143076eda") {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
