import SwiftUI

struct MainTabView: View {
    @StateObject private var recipeManager = RecipeManager()
    @State private var selectedTab: TabItem = .today
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                TodayView()
                    .environmentObject(recipeManager)
                    .tabItem {
                        Image(systemName: selectedTab == .today ? TabItem.today.selectedIcon : TabItem.today.icon)
                        Text(TabItem.today.rawValue)
                    }
                    .tag(TabItem.today)
                
                FavoritesView()
                    .environmentObject(recipeManager)
                    .tabItem {
                        Image(systemName: selectedTab == .favorites ? TabItem.favorites.selectedIcon : TabItem.favorites.icon)
                        Text(TabItem.favorites.rawValue)
                    }
                    .tag(TabItem.favorites)
                
                HistoryView()
                    .environmentObject(recipeManager)
                    .tabItem {
                        Image(systemName: selectedTab == .history ? TabItem.history.selectedIcon : TabItem.history.icon)
                        Text(TabItem.history.rawValue)
                    }
                    .tag(TabItem.history)
                
                CategoriesView()
                    .environmentObject(recipeManager)
                    .tabItem {
                        Image(systemName: selectedTab == .categories ? TabItem.categories.selectedIcon : TabItem.categories.icon)
                        Text(TabItem.categories.rawValue)
                    }
                    .tag(TabItem.categories)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: selectedTab == .settings ? TabItem.settings.selectedIcon : TabItem.settings.icon)
                        Text(TabItem.settings.rawValue)
                    }
                    .tag(TabItem.settings)
            }
            .accentColor(AppColors.primaryYellow)
            
            if recipeManager.showToast {
                VStack {
                    Spacer()
                    ToastView(message: recipeManager.toastMessage)
                        .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: recipeManager.showToast)
            }
        }
    }
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.ubuntu(14, weight: .medium))
            .foregroundColor(AppColors.textLight)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(AppColors.textPrimary)
            .cornerRadius(20)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    MainTabView()
}
