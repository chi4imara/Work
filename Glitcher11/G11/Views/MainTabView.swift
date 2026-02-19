import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    CollectionView()
                case 1:
                    StylesView()
                case 2:
                    FavoritesView()
                case 3:
                    StatisticsView()
                case 4:
                    SettingsView()
                default:
                    CollectionView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
