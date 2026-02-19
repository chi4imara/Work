import SwiftUI

struct MainTabView: View {
    @StateObject private var productViewModel = ProductViewModel()
    @State private var selectedTab: TabItem = .experiments
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .experiments:
                    ExperimentsView(viewModel: productViewModel)
                case .categories:
                    CategoriesView(viewModel: productViewModel)
                case .favorites:
                    FavoritesView(viewModel: productViewModel)
                case .statistics:
                    StatisticsView(viewModel: productViewModel)
                case .settings:
                    SettingsView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
        }
    }
}


#Preview {
    MainTabView()
}
