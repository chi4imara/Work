import SwiftUI

@main
struct MakeUpApp: App {
    @UIApplicationDelegateAdaptor(AppFacade.self) var appFacade
    @StateObject private var makeupStore = MakeupStore()
    
    init() {
        _ = FontManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            DrawShard(loader: SplashView()) {
                MainAppView()
                    .environmentObject(makeupStore)
            }
        }
    }
}
