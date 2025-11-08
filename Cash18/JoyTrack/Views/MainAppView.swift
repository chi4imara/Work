import SwiftUI

struct MainAppView: View {
    @StateObject private var eventStore = EventStore()
    @State private var selectedTab: TabItem = .calendar
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    
    private let hasSeenOnboarding = UserDefaults.standard.bool(forKey: AppConstants.UserDefaultsKeys.hasSeenOnboarding)
    
    var body: some View {
        let _ = print("🔍 MainAppView state: splash=\(showingSplash), onboarding=\(showingOnboarding), hasSeenOnboarding=\(hasSeenOnboarding)")
        
        return ZStack {
          if showingOnboarding {
                OnboardingView(onComplete: {
                    print("🚀 ONBOARDING COMPLETED!")
                    UserDefaults.standard.set(true, forKey: AppConstants.UserDefaultsKeys.hasSeenOnboarding)
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showingOnboarding = false
                    }
                })
            } else {
                MainTabView(eventStore: eventStore, selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MainTabView: View {
    @ObservedObject var eventStore: EventStore
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .calendar:
                    CalendarView(eventStore: eventStore)
                case .events:
                    AllEventsView(eventStore: eventStore)
                case .favorites:
                    FavoritesView(eventStore: eventStore)
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainAppView()
}
