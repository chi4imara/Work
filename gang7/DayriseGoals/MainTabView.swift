import SwiftUI
import UIKit

struct MainTabView: View {
    @StateObject private var dailyEntryViewModel = DailyEntryViewModel()
    @StateObject private var quotesViewModel = QuotesViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        TabView {
            MainIntentionView(dailyEntryViewModel: dailyEntryViewModel)
                .tabItem {
                    Image(systemName: "sunrise")
                    Text("Intention")
                }
                .tag(0)
            
            ArchiveView(dailyEntryViewModel: dailyEntryViewModel)
                .tabItem {
                    Image(systemName: "book")
                    Text("Archive")
                }
                .tag(1)
            
            QuotesView(quotesViewModel: quotesViewModel)
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("Quotes")
                }
                .tag(2)
            
            MoodView(dailyEntryViewModel: dailyEntryViewModel)
                .tabItem {
                    Image(systemName: "cloud.sun")
                    Text("Mood")
                }
                .tag(3)
            
            SettingsView(settingsViewModel: settingsViewModel)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.textYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(AppColors.deepBlue).withAlphaComponent(0.9)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.secondaryText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.textYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.textYellow),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
