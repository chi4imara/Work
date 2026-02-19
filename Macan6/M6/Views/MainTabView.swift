import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: TabItem = .tests
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch selectedTab {
                case .tests:
                    TestsListView()
                case .categories:
                    CategoriesView()
                case .filters:
                    FiltersView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView()
}
