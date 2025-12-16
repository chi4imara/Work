import SwiftUI

struct MainTabView: View {
    @StateObject private var appState = AppStateViewModel()
    
    var body: some View {
        ZStack {
            
            Group {
                switch appState.selectedTab {
                case .looks:
                    MakeupLooksView()
                case .products:
                    ProductsView()
                case .notes:
                    NotesView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
