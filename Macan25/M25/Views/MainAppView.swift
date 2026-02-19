import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = AccessoryViewModel()
    @State private var selectedTab: TabItem = .catalog
    @State private var selectedAccessory: Accessory?
    @State private var showingAccessoryDetail = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    switch selectedTab {
                    case .catalog:
                        CatalogView(viewModel: viewModel, selectedTab: $selectedTab)
                    case .categories:
                        CategoriesView(viewModel: viewModel, selectedTab: $selectedTab)
                    case .filters:
                        FiltersView(viewModel: viewModel, selectedTab: $selectedTab)
                    case .settings:
                        SettingsView()
                    case .add:
                        AddAccessoryView(viewModel: viewModel, selectedTab: $selectedTab)
                    }
                }
                
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainAppView()
}
