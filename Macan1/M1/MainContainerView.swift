import SwiftUI

struct MainContainerView: View {
    @StateObject private var viewModel = CosmeticViewModel()
    @State private var selectedTab: TabItem = .catalog
    @State private var showingAddProduct = false
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .catalog:
                    CatalogView(viewModel: viewModel, selectedTab: $selectedTab)
                case .favorites:
                    FavoritesView(viewModel: viewModel)
                case .filters:
                    FiltersView(viewModel: viewModel)
                case .add:
                    AddFullScreenView(viewModel: viewModel, selectedTab: $selectedTab)
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
    MainContainerView()
}
