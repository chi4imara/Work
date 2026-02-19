import SwiftUI

struct MainTabView: View {
    @StateObject private var purchaseViewModel = PurchaseViewModel()
    
    var body: some View {
        TabView {
            PurchaseListView(viewModel: purchaseViewModel)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Purchases")
                }
                .tag(0)
            
            SearchView(viewModel: purchaseViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
            
            AnalyticsView(viewModel: purchaseViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
                .tag(2)
            
            ReportsView(viewModel: purchaseViewModel)
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Reports")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorTheme.yellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(ColorTheme.primaryBlue.opacity(0.95))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont(name: "Ubuntu-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorTheme.yellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.yellow),
            .font: UIFont(name: "Ubuntu-Medium", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct PlaceholderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(ColorTheme.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 8...18))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 5...10))
                                .repeatForever(autoreverses: false),
                            value: UUID()
                        )
                }
                
                VStack(spacing: 24) {
                    Image(systemName: icon)
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(ColorTheme.white.opacity(0.7))
                    
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                        
                        Text("Coming Soon")
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.white.opacity(0.8))
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
