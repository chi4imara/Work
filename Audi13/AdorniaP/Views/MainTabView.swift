import SwiftUI

struct MainTabView: View {
    @StateObject private var navigationViewModel = NavigationViewModel()
    @StateObject private var combinationStore = CombinationStore()
    
    var body: some View {
        ZStack {
            Group {
                switch navigationViewModel.selectedTab {
                case .combinations:
                    CombinationsView(combinationStore: combinationStore)
                case .selection:
                    SelectionView(combinationStore: combinationStore)
                case .favorites:
                    FavoritesView(combinationStore: combinationStore)
                case .trends:
                    TrendsView(combinationStore: combinationStore)
                case .settings:
                    SettingsView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(navigationViewModel: navigationViewModel)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
