import SwiftUI
import GLib

@main
struct ColorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDeletegate
    @StateObject private var weatherData = WeatherDataManager()
    @StateObject private var appState = AppStateManager()
    
    init() {
        _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ContentView(weatherData: weatherData, appState: appState)
            }
        }
    }
}
