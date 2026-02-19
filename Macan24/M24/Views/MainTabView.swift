import SwiftUI

struct MainTabView: View {
    @StateObject private var breakfastViewModel = BreakfastViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyBreakfastsView(selectedTab: $selectedTab)
                .environmentObject(breakfastViewModel)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
                .tag(0)
            
            CategoriesView(selectedTab: $selectedTab)
                .environmentObject(breakfastViewModel)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Categories")
                }
                .tag(1)
            
            AddBreakfastView(selectedTab: $selectedTab)
                .environmentObject(breakfastViewModel)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(2)
            
            FiltersView(selectedTab: $selectedTab)
                .environmentObject(breakfastViewModel)
                .tabItem {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    Text("Filters")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.primaryYellow)
        .background(AnimatedBackground())
    }
}

#Preview {
    MainTabView()
}
