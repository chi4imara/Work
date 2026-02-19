import SwiftUI

struct MainTabView: View {
    @StateObject private var outfitViewModel = OutfitViewModel()
    @StateObject private var appStateViewModel = AppStateViewModel()
    
    var body: some View {
        TabView {
            MyOutfitsView(viewModel: outfitViewModel)
                .tabItem {
                    Image(systemName: "tshirt")
                    Text("My Outfits")
                }
                .tag(0)
            
            StatisticsView(viewModel: outfitViewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
                .tag(1)
            
            TagsView(viewModel: outfitViewModel)
                .tabItem {
                    Image(systemName: "tag")
                    Text("Tags")
                }
                .tag(2)
            
            CalendarView(viewModel: outfitViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(3)
            
            SettingsView(appState: appStateViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorManager.primaryText)
    }
}

#Preview {
    MainTabView()
}

