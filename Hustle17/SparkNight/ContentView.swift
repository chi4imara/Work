import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
             if appViewModel.showOnboarding {
                OnboardingView {
                    appViewModel.completeOnboarding()
                }
            } else {
                TabView(selection: $appViewModel.selectedTab) {
                    HomeView(viewModel: appViewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                    
                    WheelOfFortuneView(viewModel: appViewModel)
                        .tabItem {
                            Image(systemName: "circle.grid.cross.fill")
                            Text("Wheel")
                        }
                        .tag(1)
                    
                    ThemeGeneratorView(viewModel: appViewModel)
                        .tabItem {
                            Image(systemName: "theatermasks.fill")
                            Text("Themes")
                        }
                        .tag(2)
                    
                    FavoritesView(viewModel: appViewModel)
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Favorites")
                        }
                        .tag(3)
                    
                    StatisticsView(viewModel: appViewModel)
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("Stats")
                        }
                        .tag(4)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                        .tag(5)
                }
                .accentColor(ColorTheme.primaryBlue)
            }
        }
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(ColorTheme.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.textSecondary),
            .font: UIFont(name: "Poppins-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.blue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.blue),
            .font: UIFont(name: "Poppins-SemiBold", size: 10) ?? UIFont.boldSystemFont(ofSize: 10)
        ]
        
        appearance.inlineLayoutAppearance = appearance.stackedLayoutAppearance
        appearance.compactInlineLayoutAppearance = appearance.stackedLayoutAppearance
        
        UITabBar.appearance().standardAppearance = appearance
    }
}

extension UIImage {
    static func createSelectionCircle(color: UIColor, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
            circlePath.fill()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
