import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        TabView {
            AddSneakerView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add")
                }
            
            CollectionView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Collection")
                }
            
            WearingView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Wearing")
                }
            
            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Analytics")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(ColorManager.lightBlue)
        .preferredColorScheme(.dark)
        .environmentObject(dataManager)
    }
}

#Preview {
    MainTabView()
}
