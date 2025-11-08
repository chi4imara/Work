import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = SeriesViewModel()
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(viewModel: viewModel, selectedTab: $selectedTab)
                case .categories:
                    CategoriesView(viewModel: viewModel, selectedTab: $selectedTab)
                case .progress:
                    SeriesProgressView(viewModel: viewModel)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
