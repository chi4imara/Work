import SwiftUI
import GLib

@main
struct CollectionFansApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    @StateObject private var store = CollectionStore()
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
            Group {
                if !appState.hasSeenOnboarding {
                    OnboardingView(appState: appState)
                } else {
                    MainTabView(appState: appState, store: store)
                }
            }
            .preferredColorScheme(.light)
        }
    }
    }
}
