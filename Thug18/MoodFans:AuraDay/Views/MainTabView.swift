import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .calendar
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .calendar:
                        CalendarView(onNavigateToAnalytics: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .analytics
                            }
                        })
                    case .analytics:
                        MoodAnalyticsView()
                    case .favorites:
                        FavoritesView()
                    case .settings:
                        SettingsView()
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

#Preview {
    MainTabView()
}
