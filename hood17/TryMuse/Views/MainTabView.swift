import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ListViewModel()
    @State private var selectedTab: TabItem = .lists
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .lists:
                        ListsView(viewModel: viewModel)
                    case .history:
                        HistoryView(viewModel: viewModel)
                    case .statistics:
                        StatisticsView(viewModel: viewModel)
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
