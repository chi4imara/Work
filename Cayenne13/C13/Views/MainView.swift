import SwiftUI

struct MainView: View {
    @StateObject private var watchViewModel = WatchViewModel()
    @State private var selectedTab = 0
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    
    var body: some View {
        ZStack {
            if showingOnboarding {
                OnboardingView(isShowingOnboarding: $showingOnboarding)
            } else {
                mainContent
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
            checkOnboardingStatus()
        }
    }
    
    private func checkOnboardingStatus() {
        showingOnboarding = !DataManager.shared.hasSeenOnboarding()
    }
    
    
    private var mainContent: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
                Group {
                    switch selectedTab {
                    case 0:
                        AddWatchView(viewModel: watchViewModel)
                    case 1:
                        CollectionView(viewModel: watchViewModel)
                    case 2:
                        WearingView(viewModel: watchViewModel)
                    case 3:
                        StatisticsView(viewModel: watchViewModel)
                    case 4:
                        SettingsView()
                    default:
                        AddWatchView(viewModel: watchViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainView()
}
