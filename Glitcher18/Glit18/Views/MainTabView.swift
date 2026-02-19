import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        TabView {
            AccessoriesView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Accessories")
                }
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Categories")
                }
                .tag(1)
            
            OutfitsView()
                .tabItem {
                    Image(systemName: "tshirt.fill")
                    Text("Outfits")
                }
                .tag(2)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.accentYellow)
        .environmentObject(dataManager)
    }
}


#Preview {
    MainTabView()
}
