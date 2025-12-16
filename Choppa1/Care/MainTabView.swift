import SwiftUI

enum TabSelection: Int {
    case mySalon = 0
    case products = 1
    case statistics = 2
    case settings = 3
}

struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showOnboarding = false
    @State private var selectedTab: TabSelection = .mySalon
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MySalonView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("My Salon")
                }
                .tag(TabSelection.mySalon)
            
            ProductsView()
                .tabItem {
                    Image(systemName: "waterbottle")
                    Text("Products")
                }
                .tag(TabSelection.products)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(TabSelection.statistics)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(TabSelection.settings)
        }
        .accentColor(AppColors.primaryText)
        .onAppear {
            checkFirstLaunch()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToMySalonTab"))) { _ in
            selectedTab = .mySalon
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToProductsTab"))) { _ in
            selectedTab = .products
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToStatisticsTab"))) { _ in
            selectedTab = .statistics
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if !hasLaunchedBefore {
            showOnboarding = true
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DataManager())
}
