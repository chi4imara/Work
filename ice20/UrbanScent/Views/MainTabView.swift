import SwiftUI

struct MainTabView: View {
    @StateObject private var scentViewModel = ScentViewModel()
    @StateObject private var appStateViewModel = AppStateViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Group {
                    switch appStateViewModel.selectedTab {
                    case 0:
                        TodayView(viewModel: scentViewModel)
                    case 1:
                        ArchiveView(viewModel: scentViewModel, appViewModel: appStateViewModel)
                    case 2:
                        StatsView(viewModel: scentViewModel)
                    case 3:
                        CollectionView(viewModel: scentViewModel)
                    case 4:
                        SettingsView()
                    default:
                        TodayView(viewModel: scentViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appStateViewModel.selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
