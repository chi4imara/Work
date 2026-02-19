import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ToolViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ToolCatalogView(viewModel: viewModel, selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "list.bullet.circle.fill" : "list.bullet.circle")
                        Text("Catalog")
                    }
                    .tag(0)
                
                ToolTypesView(viewModel: viewModel, selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: selectedTab == 1 ? "folder.fill" : "folder")
                        Text("Types")
                    }
                    .tag(1)
                
                StorageLocationsView(viewModel: viewModel, selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "location.fill" : "location")
                        Text("Storage")
                    }
                    .tag(2)
                
                AddToolView(viewModel: viewModel, selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .tag(3)
                
                SettingsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        Text("Settings")
                    }
                    .tag(4)
            }
            .accentColor(ColorTheme.accentOrange)
            .onAppear {
                setupTabBarAppearance()
            }
            .sheet(item: Binding<ToolIDWrapper?>(
                get: { 
                    guard let id = viewModel.selectedToolId,
                          viewModel.getTool(by: id) != nil else { return nil }
                    return ToolIDWrapper(id: id)
                },
                set: { viewModel.selectedToolId = $0?.id }
            )) { wrapper in
                if let tool = viewModel.getTool(by: wrapper.id) {
                    ToolDetailView(tool: tool, viewModel: viewModel)
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(ColorTheme.secondaryBackground)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(ColorTheme.mutedText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.mutedText),
            .font: UIFont(name: "Ubuntu-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorTheme.accentOrange)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.accentOrange),
            .font: UIFont(name: "Ubuntu-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ToolIDWrapper: Identifiable {
    let id: UUID
}

#Preview {
    MainTabView()
}
