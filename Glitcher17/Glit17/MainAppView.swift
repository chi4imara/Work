import SwiftUI

struct MainAppView: View {
    @StateObject private var appState = AppState()
    @State private var selectedTab = 0
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
            if !appState.hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $appState.hasCompletedOnboarding)
                    .transition(.slide)
            } else {
                mainContent
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
            }
        }
        .onChange(of: appState.hasCompletedOnboarding) { completed in
            if completed {
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            }
        }
    }
    
    private var mainContent: some View {
        NavigationStack {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                Group {
                    switch selectedTab {
                    case 0:
                        ScheduleView(appState: appState)
                    case 1:
                        CategoriesView(appState: appState)
                    case 2:
                        HistoryView(appState: appState)
                    case 3:
                        StatisticsView(appState: appState)
                    case 4:
                        SettingsView(appState: appState)
                    default:
                        ScheduleView(appState: appState)
                    }
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainAppView()
}
