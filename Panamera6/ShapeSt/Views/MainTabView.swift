import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = StyleViewModel()
    @State private var selectedTab: TabItem = .catalog
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .catalog:
                    CatalogView(viewModel: viewModel)
                case .categories:
                    CategoriesView(viewModel: viewModel)
                case .favorites:
                    FavoritesView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
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
    }
}

