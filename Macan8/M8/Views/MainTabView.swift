import SwiftUI

struct MainTabView: View {
    @StateObject private var nailIdeasViewModel = NailIdeasViewModel()
    @ObservedObject var appState: AppStateViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch appState.selectedTab {
                case 0:
                    MainCollectionView(viewModel: nailIdeasViewModel, selectedTab: $appState.selectedTab)
                case 1:
                    NewIdeaView(viewModel: nailIdeasViewModel, selectedTab: $appState.selectedTab)
                case 2:
                    CollectionsView(viewModel: nailIdeasViewModel)
                case 3:
                    FiltersView(viewModel: nailIdeasViewModel, selectedTab: $appState.selectedTab)
                case 4:
                    SettingsView()
                default:
                    MainCollectionView(viewModel: nailIdeasViewModel, selectedTab: $appState.selectedTab)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: Binding(
                    get: { appState.selectedTab },
                    set: { newValue in
                        appState.saveSelectedTab(newValue)
                    }
                ))
            }
        }
    }
}

#Preview {
    MainTabView(appState: AppStateViewModel())
}
