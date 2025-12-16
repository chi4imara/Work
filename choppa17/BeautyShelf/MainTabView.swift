import SwiftUI

struct MainTabView: View {
    @StateObject private var appViewModel = AppViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch selectedTab {
                case 0:
                    StorageLocationsView()
                case 1:
                    AllProductsView()
                case 2:
                    SearchView()
                case 3:
                    AnalyticsView()
                case 4:
                    SettingsView()
                default:
                    StorageLocationsView()
                }
            }
            .environmentObject(appViewModel)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}


#Preview {
    MainTabView()
}
