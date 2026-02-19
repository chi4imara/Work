import SwiftUI
import HookEther_Knowledge_Base

@main
struct FriendsFitnessApp: App {
    @UIApplicationDelegateAdaptor(AppAssembly.self) var appAssembly
    @StateObject private var viewModel = RitualViewModel()
    @State private var showSplash = true
    
    init() {
        FontManager.shared.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            AganimProphet(loader: SplashScreenView(showSplash: $showSplash)) {
                ZStack {
                    if !viewModel.hasCompletedOnboarding {
                        OnboardingView(viewModel: viewModel)
                    } else {
                        NavigationStack {
                            MainTabView(viewModel: viewModel)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
}

struct MainTabView: View {
    @ObservedObject var viewModel: RitualViewModel
    
    var body: some View {
        TabView {
            CatalogView(viewModel: viewModel)
                .tabItem {
                    Label("Catalog", systemImage: "list.bullet")
                }
            
            CalendarView(viewModel: viewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            ProfileView(viewModel: viewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(AppColors.accentPurple)
    }
}
