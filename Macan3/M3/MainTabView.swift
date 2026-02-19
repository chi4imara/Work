import SwiftUI

struct MainTabView: View {
    @StateObject private var fragranceViewModel = FragranceViewModel()
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch appViewModel.currentTab {
                case .collection:
                    CollectionView(viewModel: fragranceViewModel)
                case .seasons:
                    SeasonsView(viewModel: fragranceViewModel)
                case .filters:
                    FiltersView(viewModel: fragranceViewModel)
                case .statistics:
                    StatisticsView(viewModel: fragranceViewModel)
                case .settings:
                    SettingsView(appViewModel: appViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.currentTab)
            }
        }
    }
}

#Preview {
    MainTabView(appViewModel: AppViewModel())
}
