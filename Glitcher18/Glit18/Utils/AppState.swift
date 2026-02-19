import SwiftUI
import Combine

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: "HasSeenOnboarding")
        }
    }
    
    private init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    }
    
    func resetOnboarding() {
        hasSeenOnboarding = false
    }
}
