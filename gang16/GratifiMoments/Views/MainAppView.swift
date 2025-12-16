import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = GratitudeViewModel()
    @State private var selectedTab = 0
    @State private var showingSplash = true
    @State private var showingOnboarding = true
    
    var body: some View {
        ZStack {
            if showingSplash {
                SplashView()
                    .onAppear {
                        FontManager.shared.registerFonts()
                        
                        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showingSplash = false
                                if !hasSeenOnboarding {
                                    showingOnboarding = true
                                }
                            }
                        }
                    }
            } else if !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") && showingOnboarding {
                OnboardingView(isOnboardingComplete: $showingOnboarding)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
            } else {
                mainContentView
            }
        }
        .animation(.easeInOut, value: showingSplash)
        .animation(.easeInOut, value: showingOnboarding)
    }
    
    private var mainContentView: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        HomeView(viewModel: viewModel) { newTab in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = newTab
                            }
                        }
                    case 1:
                        JournalView(viewModel: viewModel, selectedTab: $selectedTab)
                    case 2:
                        RandomGratitudeView(viewModel: viewModel, selectedTab: $selectedTab)
                    case 3:
                        TipsView(selectedTab: $selectedTab)
                    case 4:
                        SettingsView()
                    default:
                        HomeView(viewModel: viewModel) { newTab in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = newTab
                            }
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainAppView()
}
