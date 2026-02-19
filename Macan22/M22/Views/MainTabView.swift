import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .collection
    @StateObject private var viewModel = ScentViewModel()

    var body: some View {
        ZStack {
            AppBackground()
            
            Group {
                switch selectedTab {
                case .collection:
                    CollectionView(viewModel: viewModel, selectedTab: $selectedTab)
                case .categories:
                    CategoriesView(viewModel: viewModel, selectedTab: $selectedTab)
                case .filters:
                    FiltersView(viewModel: viewModel, selectedTab: $selectedTab)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                case .settings:
                    SettingsView()
                }
            }
            
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
