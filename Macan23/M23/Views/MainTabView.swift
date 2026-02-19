import SwiftUI

struct MainTabView: View {
    @StateObject private var habitsViewModel = HabitsViewModel()
    @State private var selectedTab = 0
    @State private var isTabBarReady = false
    
    var body: some View {
        Group {
            if isTabBarReady {
                TabView(selection: $selectedTab) {
                    HabitsListView(selectedTab: $selectedTab)
                        .environmentObject(habitsViewModel)
                        .tabItem {
                            Image(systemName: "book.fill")
                            Text("Journal")
                        }
                        .tag(0)
                    
                    CategoriesView(selectedTab: $selectedTab)
                        .environmentObject(habitsViewModel)
                        .tabItem {
                            Image(systemName: "square.grid.3x3.fill")
                            Text("Categories")
                        }
                        .tag(1)
                    
                    AddHabitView(selectedTab: $selectedTab)
                        .environmentObject(habitsViewModel)
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                            Text("Add")
                        }
                        .tag(2)
                    
                    FiltersView(selectedTab: $selectedTab)
                        .environmentObject(habitsViewModel)
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
                .accentColor(AppColors.accent)
            } else {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTabBarReady = true
            }
        }
    }
}
