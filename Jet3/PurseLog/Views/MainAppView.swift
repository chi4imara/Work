import SwiftUI

struct MainAppView: View {
    @State private var selectedTab: TabItem = .collection
    @State private var showingSplash = true
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "HasCompletedOnboarding")
    
    var body: some View {
        ZStack {
          if !hasCompletedOnboarding {
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "HasCompletedOnboarding")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasCompletedOnboarding = true
                    }
                }
            } else {
                mainContentView
            }
        }
    }
    
    private var mainContentView: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch selectedTab {
                case .collection:
                    BagCollectionView()
                case .statistics:
                    StatisticsView()
                case .notes:
                    NotesView()
                case .info:
                    InfoView(selectedTab: $selectedTab)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
