import SwiftUI
import LibSync

@main
struct DreamCartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = BeautyDiaryViewModel()
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView(viewModel: viewModel)) {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}
