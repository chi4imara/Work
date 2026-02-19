import SwiftUI

struct MainTabView: View {
    @StateObject private var ideasViewModel = IdeasViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            Group {
                switch selectedTab {
                case 0:
                    IdeasListView(viewModel: ideasViewModel, selectedTab: $selectedTab)
                case 1:
                    SearchView(viewModel: ideasViewModel)
                case 2:
                    AddIdeaView(viewModel: ideasViewModel, selectedTab: $selectedTab)
                case 3:
                    FavoritesView(viewModel: ideasViewModel)
                case 4:
                    SettingsView(
                        ideasViewModel: ideasViewModel,
                        settingsViewModel: settingsViewModel
                    )
                default:
                    IdeasListView(viewModel: ideasViewModel, selectedTab: $selectedTab)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
