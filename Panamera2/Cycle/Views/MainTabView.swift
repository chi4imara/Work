import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .jewelry
    @StateObject private var store = JewelryStore()

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .jewelry:
                    JewelryListView()
                case .categories:
                    CategoriesView()
                case .recent:
                    RecentView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            .environmentObject(store)
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


#Preview {
    MainTabView()
}
