import SwiftUI

@main
struct ThisIApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly: AppAssembly
    @StateObject private var viewModel = DecisionViewModel()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashView()) {
                NavigationStack {
                    ContentView()
                        .environmentObject(viewModel)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
