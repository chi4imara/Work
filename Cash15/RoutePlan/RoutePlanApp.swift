import SwiftUI
import GLib

@main
struct RoutePlanApp: App {
    @StateObject private var dataManager = DataManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen {
                AppRootView()
                    .environmentObject(dataManager)
            }
        }
    }
}
