import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = GiftManagerViewModel()
    @State private var selectedTab: TabItem = .people
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .people:
                        PeopleView(viewModel: viewModel)
                    case .ideas:
                        IdeasListView(viewModel: viewModel)
                    case .statistics:
                        StatisticsView(viewModel: viewModel, selectedTab: $selectedTab)
                    case .settings:
                        SettingsView()
                    }
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
