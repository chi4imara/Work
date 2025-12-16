import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = HobbyIdeaViewModel()
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
                    case .categories:
                        CategoriesView(viewModel: viewModel)
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainAppView()
}
