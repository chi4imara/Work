import SwiftUI
import GLib

extension Notification.Name {
    static let resetOnboarding = Notification.Name("resetOnboarding")
}

@main
struct DailyEmotionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataManager = EmotionDataManager()
    @State private var showSplash = false
    @AppStorage("OnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if !isOnboardingCompleted {
                        OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                            .onAppear {
                                print("📱 OnboardingView appeared")
                            }
                    } else {
                        MainTabView()
                            .environmentObject(dataManager)
                            .onAppear {
                                print("🏠 MainTabView appeared - Onboarding completed: \(isOnboardingCompleted)")
                            }
                            .onReceive(NotificationCenter.default.publisher(for: .resetOnboarding)) { _ in
                                print("🔄 Received reset onboarding notification")
                                isOnboardingCompleted = false
                            }
                    }
                }
            }
        }
    }
}
