import SwiftUI

struct MainTabView: View {
    @StateObject private var outfitViewModel = OutfitViewModel()
    @State private var selectedTab: TabItem = .home
    @State private var showingAddOutfit = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .home:
                    HomeView(selectedTab: $selectedTab)
                case .categories:
                    CategoriesView()
                case .favorites:
                    FavoritesView()
                case .add:
                    AddOutfitView(selectedTab: $selectedTab)
                case .settings:
                    SettingsView()
                }
            }
            .environmentObject(outfitViewModel)
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
