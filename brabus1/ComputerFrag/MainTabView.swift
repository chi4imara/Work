import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = DeviceViewModel()
    @State private var selectedTab: TabItem = .devices
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .devices:
                    MyTechView(viewModel: viewModel)
                case .categories:
                    CategoriesView(viewModel: viewModel)
                case .upgrades:
                    UpgradePlanView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                case .settings:
                    SettingsView(viewModel: viewModel)
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


#Preview {
    MainTabView()
}
