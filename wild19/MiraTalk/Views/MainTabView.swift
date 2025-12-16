import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedTab: TabItem = .today
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .today:
                        TodayView(viewModel: viewModel, selectedTab: $selectedTab)
                    case .favorites:
                        FavoritesView(viewModel: viewModel)
                    case .history:
                        HistoryView(viewModel: viewModel)
                    case .collections:
                        CollectionsView(viewModel: viewModel)
                    case .settings:
                        SettingsView(viewModel: viewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    MainTabView(viewModel: AppViewModel())
}
