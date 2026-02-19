import SwiftUI

struct MainTabView: View {
    @StateObject private var toolsViewModel = ToolsViewModel()
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch appViewModel.selectedTab {
                case 0: AddToolView(toolsViewModel: toolsViewModel)
                case 1: CatalogView(toolsViewModel: toolsViewModel)
                case 2: ToolTypesView(toolsViewModel: toolsViewModel)
                case 3: SearchView(toolsViewModel: toolsViewModel)
                case 4: SettingsView()
                default: AddToolView(toolsViewModel: toolsViewModel)
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
