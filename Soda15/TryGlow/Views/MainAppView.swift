import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = BeautyProductViewModel()
    @State private var selectedTab: TabItem = .discoveries
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .discoveries:
                    DiscoveriesView(viewModel: viewModel)
                case .categories:
                    CategoriesView(viewModel: viewModel)
                case .notes:
                    NotesView(viewModel: viewModel)
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
    }
}

#Preview {
    MainAppView()
}
