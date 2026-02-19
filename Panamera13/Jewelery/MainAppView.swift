import SwiftUI

struct MainAppView: View {
    @StateObject private var jewelryStore = JewelryStore()
    @StateObject private var setsStore = SetsStore()
    @StateObject private var settingsStore = SettingsStore()
    @State private var selectedTab: TabItem = .jewelry
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .jewelry:
                    JewelryListView(jewelryStore: jewelryStore, setsStore: setsStore)
                case .sets:
                    SetsView(setsStore: setsStore, jewelryStore: jewelryStore)
                case .favorites:
                    FavoritesView(jewelryStore: jewelryStore, setsStore: setsStore)
                case .search:
                    StatisticsView(jewelryStore: jewelryStore, setsStore: setsStore)
                case .settings:
                    SettingsView(settingsStore: settingsStore)
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainAppView()
}
