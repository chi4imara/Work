import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .quotes
    @StateObject private var quoteManager = QuoteManager.shared

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .quotes:
                    QuotesCollectionView(quoteManager: quoteManager, selectedTab: $selectedTab)
                case .themes:
                    ThemesView(quoteManager: quoteManager, selectedTab: $selectedTab)
                case .filters:
                    FiltersView(quoteManager: quoteManager, selectedTab: $selectedTab)
                case .search:
                    NavigationStack {
                        SearchView(quoteManager: quoteManager)
                            .navigationBarHidden(true)
                    }
                case .settings:
                    SettingsView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .primaryBackground()
    }
}

#Preview {
    MainTabView()
}
