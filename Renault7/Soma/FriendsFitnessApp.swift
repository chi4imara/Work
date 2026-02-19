import SwiftUI

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @State private var isLoading = true
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        FontManager.shared.reg()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView()) {
                MainAppView()
                    .onChange(of: scenePhase) { newPhase in
                        switch newPhase {
                        case .inactive, .background:
                            DataManager.shared.persistNow()
                        default:
                            break
                        }
                    }
            }
        }
    }
}
