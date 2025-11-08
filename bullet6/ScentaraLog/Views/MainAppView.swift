import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = ScentDiaryViewModel()
    @State private var selectedTab = 0
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.hasSeenOnboarding)
    
    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView(isCompleted: $hasSeenOnboarding)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.hasSeenOnboarding)
                    }
            } else {
                mainContentView
            }
        }
        .onAppear {
            FontRegistration.registerFonts()
        }
    }
    
    private var mainContentView: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        ScentDiaryView(viewModel: viewModel, selectedTab: $selectedTab)
                    case 1:
                        QuickAddEntry(viewModel: viewModel)
                    case 2:
                        CategoriesView(viewModel: viewModel)
                    case 3:
                        TipsView(viewModel: viewModel)
                    case 4:
                        SettingsView()
                    default:
                        ScentDiaryView(viewModel: viewModel, selectedTab: $selectedTab)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}
