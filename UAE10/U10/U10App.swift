import SwiftUI
import LibSync

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var measurementStore = MeasurementStore()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreenView()) {
                AppRootView()
                    .environmentObject(measurementStore)
            }
        }
    }
}
