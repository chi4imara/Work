import SwiftUI
import StoreKit
import HookEther_Knowledge_Base

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                ZStack {
                    if !hasSeenOnboarding {
                        OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                            .environmentObject(inventoryViewModel)
                    } else {
                        NavigationStack {
                            ContentView()
                                .environmentObject(inventoryViewModel)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
}
