import SwiftUI
import LibSync

@main
struct LoveiSpiceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: LoadingView()) {
                AppContainerView()
            }
        }
    }
}
