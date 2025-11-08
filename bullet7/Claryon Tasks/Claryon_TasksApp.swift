import SwiftUI
import LibSync

@main
struct Claryon_TasksApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = CleaningZoneViewModel()
    @State private var showingSplash = true
    
    init() {
        BundleHelper.shared.checkFontFiles()
        BundleHelper.shared.listAllFontFiles()
        FontHelper.shared.registerFonts()
        FontHelper.shared.listAvailableFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                ZStack {
                    if viewModel.showingOnboarding {
                        OnboardingView(viewModel: viewModel)
                    } else {
                        MainTabView()
                            .environmentObject(viewModel)
                    }
                }
            }
        }
    }
}
