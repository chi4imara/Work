import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = WardrobeViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    WardrobeView()
                case 1:
                    OutfitsView()
                case 2:
                    StatisticsView()
                case 3:
                    HistoryView()
                case 4:
                    SettingsView()
                default:
                    WardrobeView()
                }
            }
            .environmentObject(viewModel)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
